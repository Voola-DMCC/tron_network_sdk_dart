import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:bs58check/bs58check.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/utils/typed_data.dart';
import 'core/bip32.dart';

const TRX_MESSAGE_HEADER = '\x19TRON Signed Message:\n32';
const ETH_MESSAGE_HEADER = '\x19Ethereum Signed Message:\n32';

RegExp _hexadecimal = RegExp(r'^[0-9a-fA-F]+$');

class TronWallet {
  late EthPrivateKey privateKey;
  late String hexAddress;
  late String bs58Address;

  TronWallet({required this.privateKey, required this.hexAddress}) {
    bs58Address = TronWallet.hexToBs58Address(hexAddress);
  }

  TronWallet.fromPrivateKey(String privateKeyHex) {
    privateKey = EthPrivateKey.fromHex(privateKeyHex);
    hexAddress = addressFromPub(privateKey.encodedPublicKey);
    bs58Address = TronWallet.hexToBs58Address(hexAddress);
  }

  Uint8List signString(String hexMessage, [bool useTronHeader = true]) {
    final messageBytes = hexToBytes(hexMessage);
    var signature = sign(messageBytes, privateKey.privateKey);
    final r = padUint8ListTo32(unsignedIntToBytes(signature.r));
    final s = padUint8ListTo32(unsignedIntToBytes(signature.s));
    final v = unsignedIntToBytes(BigInt.from(signature.v));
    return uint8ListFromList(r + s + v);
  }

  factory TronWallet.fromMnemonic(String mnemonic) {
    if (validateMnemonic(mnemonic)) {
      final seed = mnemonicToSeed(mnemonic);
      final bip32inst = BIP32.fromSeed(seed).derivePath("m/44'/195'/0'/0/0");
      final privateKeyHex = bytesToHex(bip32inst.privateKey!.toList());
      return TronWallet.fromPrivateKey(privateKeyHex);
    } else
      throw ArgumentError('Invalid mnemonic');
  }

  factory TronWallet.fromSeed(Uint8List seed) {
    final bip32inst = BIP32.fromSeed(seed).derivePath("m/44'/195'/0'/0/0");
    final privateKeyHex = bytesToHex(bip32inst.privateKey!.toList());
    return TronWallet.fromPrivateKey(privateKeyHex);
  }

  static String addressFromPub(Uint8List pubBytes) {
    final pubHash = keccak256(pubBytes);
    return '41${bytesToHex(pubHash).substring(24)}';
  }

  static String hexToBs58Address(String hexAddress) {
    final addrBytes = hexToBytes(hexAddress);
    final hash0 = SHA256Digest().process(addrBytes);
    final hash1 = SHA256Digest().process(hash0);
    final checkSum = hash1.sublist(0, 4);
    return base58.encode(Uint8List.fromList([...addrBytes, ...checkSum]));
  }

  static String bs58ToHexAddress(String bs58Address) {
    final decoded = base58.decode(bs58Address);
    final addrBytes = decoded.sublist(0, decoded.length - 4);
    return bytesToHex(addrBytes);
  }

  static bool isHexAddress(String address) {
    return _hexadecimal.hasMatch(address);
  }

  static EthereumAddress tronAddressToEthAddress(String tronAddress) {
    if (!TronWallet.isHexAddress(tronAddress)) {
      tronAddress = bs58ToHexAddress(tronAddress);
    }
    return EthereumAddress.fromHex(tronAddress.replaceFirst('41', '0x'));
  }

  static String ethAddressToTronAddress(EthereumAddress ethAddress) {
    return hexToBs58Address(ethAddress.hex.replaceFirst('0x', '41'));
  }

  static bool isValidBs58Address(String address) {
    try {
      var decodedAddr = bs58ToHexAddress(address);
      return decodedAddr.startsWith('41') && decodedAddr.length == 42;
    } catch (e) {
      return false;
    }
  }
}
