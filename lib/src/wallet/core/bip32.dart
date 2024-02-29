import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

import 'ecurve.dart' as ecc;

class Bip32Type {
  int? public;
  int? private;
  Bip32Type({this.public, this.private});
}

class NetworkType {
  int? wif;
  Bip32Type? bip32;
  NetworkType({this.wif, this.bip32});
}

final _BITCOIN = NetworkType(wif: 0x80, bip32: Bip32Type(public: 0x0488b21e, private: 0x0488ade4));
const HIGHEST_BIT = 0x80000000;
const UINT31_MAX = 2147483647; // 2^31 - 1
const UINT32_MAX = 4294967295; // 2^32 - 1

class BIP32 {
  Uint8List? _d;
  Uint8List? _Q;
  Uint8List? _Q_uncompressed;
  Uint8List? chainCode;
  int depth = 0;
  int index = 0;
  NetworkType network;
  int parentFingerprint = 0x00000000;
  BIP32(this._d, this._Q, this.chainCode, this.network);

  Uint8List? get publicKey {
    _Q ??= ecc.pointFromScalar(_d!, true);
    return _Q;
  }

  Uint8List? get privateKey => _d;
  Uint8List get identifier => hash160(publicKey!);
  Uint8List get fingerprint => identifier.sublist(0, 4);

  bool isNeutered() {
    return _d == null;
  }

  BIP32 derive(int index) {
    if (index > UINT32_MAX || index < 0) throw ArgumentError('Expected UInt32');
    final isHardened = index >= HIGHEST_BIT;
    var data = Uint8List(37);
    if (isHardened) {
      if (isNeutered()) {
        throw ArgumentError('Missing private key for hardened child key');
      }
      data[0] = 0x00;
      data.setRange(1, 33, privateKey!);
      data.buffer.asByteData().setUint32(33, index);
    } else {
      data.setRange(0, 33, publicKey!);
      data.buffer.asByteData().setUint32(33, index);
    }
    final I = hmacSHA512(chainCode!, data);
    final IL = I.sublist(0, 32);
    final IR = I.sublist(32);
    if (!ecc.isPrivate(IL)) {
      return derive(index + 1);
    }
    BIP32 hd;
    if (!isNeutered()) {
      final ki = ecc.privateAdd(privateKey!, IL);
      if (ki == null) return derive(index + 1);
      hd = BIP32.fromPrivateKey(ki, IR, network);
    } else {
      final ki = ecc.pointAddScalar(publicKey!, IL, true);
      if (ki == null) return derive(index + 1);
      hd = BIP32.fromPublicKey(ki, IR, network);
    }
    hd.depth = depth + 1;
    hd.index = index;
    hd.parentFingerprint = fingerprint.buffer.asByteData().getUint32(0);
    return hd;
  }

  BIP32 deriveHardened(int index) {
    if (index > UINT31_MAX || index < 0) throw ArgumentError('Expected UInt31');
    return derive(index + HIGHEST_BIT);
  }

  BIP32 derivePath(String path) {
    final regex = RegExp(r"^(m\/)?(\d+'?\/)*\d+'?$");
    if (!regex.hasMatch(path)) throw ArgumentError('Expected BIP32 Path');
    var splitPath = path.split('/');
    if (splitPath[0] == 'm') {
      if (parentFingerprint != 0) throw ArgumentError('Expected master, got child');
      splitPath = splitPath.sublist(1);
    }
    return splitPath.fold(this, (BIP32 prevHd, String indexStr) {
      int index;
      if (indexStr.substring(indexStr.length - 1) == "'") {
        index = int.parse(indexStr.substring(0, indexStr.length - 1));
        return prevHd.deriveHardened(index);
      } else {
        index = int.parse(indexStr);
        return prevHd.derive(index);
      }
    });
  }

  factory BIP32.fromPublicKey(Uint8List publicKey, Uint8List? chainCode, [NetworkType? nw]) {
    var network = nw ?? _BITCOIN;
    if (!ecc.isPoint(publicKey)) {
      throw ArgumentError('Point is not on the curve');
    }
    return BIP32(null, publicKey, chainCode, network);
  }

  factory BIP32.fromPrivateKey(Uint8List privateKey, Uint8List? chainCode, [NetworkType? nw]) {
    var network = nw ?? _BITCOIN;
    if (privateKey.length != 32) throw ArgumentError('Expected property privateKey of type Buffer(Length: 32)');
    if (!ecc.isPrivate(privateKey)) throw ArgumentError('Private key not in range [1, n]');
    return BIP32(privateKey, null, chainCode, network);
  }

  factory BIP32.fromSeed(Uint8List seed, [NetworkType? nw]) {
    if (seed.length < 16) {
      throw ArgumentError('Seed should be at least 128 bits');
    }
    if (seed.length > 64) {
      throw ArgumentError('Seed should be at most 512 bits');
    }
    var network = nw ?? _BITCOIN;
    final I = hmacSHA512(utf8.encode('Bitcoin seed') as Uint8List, seed);
    final IL = I.sublist(0, 32);
    final IR = I.sublist(32);
    return BIP32.fromPrivateKey(IL, IR, network);
  }
}

Uint8List hmacSHA512(Uint8List key, Uint8List data) {
  final _tmp = HMac(SHA512Digest(), 128)..init(KeyParameter(key));
  return _tmp.process(data);
}

Uint8List hash160(Uint8List buffer) {
  var _tmp = SHA256Digest().process(buffer);
  return RIPEMD160Digest().process(_tmp);
}
