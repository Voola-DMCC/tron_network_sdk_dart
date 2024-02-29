import 'transaction.dart';

class Block {
  String? blockID;
  BlockHeader? blockHeader;
  List<Transaction>? transactions;

  Block({this.blockID, this.blockHeader, this.transactions});

  Block.fromJson(Map<String, dynamic> json) {
    blockID = json['blockID'];
    blockHeader = json['block_header'] != null ? BlockHeader.fromJson(json['block_header']) : null;
    if (json['transactions'] != null) {
      transactions = <Transaction>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transaction.fromJson(v));
      });
    }
  }
}

class BlockHeader {
  RawData? rawData;
  String? witnessSignature;

  BlockHeader({this.rawData, this.witnessSignature});

  BlockHeader.fromJson(Map<String, dynamic> json) {
    rawData = json['raw_data'] != null ? RawData.fromJson(json['raw_data']) : null;
    witnessSignature = json['witness_signature'];
  }
}

class RawData {
  int? number;
  String? txTrieRoot;
  String? witnessAddress;
  String? parentHash;
  int? version;
  int? timestamp;

  RawData({this.number, this.txTrieRoot, this.witnessAddress, this.parentHash, this.version, this.timestamp});

  RawData.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    txTrieRoot = json['txTrieRoot'];
    witnessAddress = json['witness_address'];
    parentHash = json['parentHash'];
    version = json['version'];
    timestamp = json['timestamp'];
  }
}
