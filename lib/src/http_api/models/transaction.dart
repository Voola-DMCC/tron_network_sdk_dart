import 'dart:convert' as conv;

import 'package:web3dart/crypto.dart';

class Transaction {
  List<Transaction_Ret>? ret;
  List<String>? signature;
  String? txID;
  Transaction_RawData? rawData;
  String? rawDataHex;
  bool? visible;
  String? rawDataJsonRaw;

  Transaction({this.ret, this.visible, this.signature, this.txID, this.rawData, this.rawDataHex});

  Transaction.fromJson(Map<String, dynamic> json) {
    if (json['ret'] != null) {
      ret = <Transaction_Ret>[];
      json['ret'].forEach((v) {
        ret!.add(Transaction_Ret.fromJson(v));
      });
    }
    if (json['signature'] != null) signature = json['signature'].cast<String>();
    txID = json['txID'];
    visible = json['visible'];
    rawDataJsonRaw = conv.json.encode(json['raw_data']);
    rawData = json['raw_data'] != null ? Transaction_RawData.fromJson(json['raw_data']) : null;
    rawDataHex = json['raw_data_hex'];
  }

  int getTxBytesLength() {
    return hexToBytes(signature!.first).length + hexToBytes(rawDataHex!).length + 9 + 60;
  }
}

class Transaction_Ret {
  String? contractRet;

  Transaction_Ret({this.contractRet});

  Transaction_Ret.fromJson(Map<String, dynamic> json) {
    contractRet = json['contractRet'];
  }
}

class Transaction_RawData {
  String? data;
  List<Transaction_RawData_Contract>? contract;
  String? refBlockBytes;
  String? refBlockHash;
  int? expiration;
  int? timestamp;
  int? feeLimit;

  Transaction_RawData({this.data, this.contract, this.refBlockBytes, this.refBlockHash, this.expiration, this.timestamp, this.feeLimit});

  Transaction_RawData.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    if (json['contract'] != null) {
      contract = <Transaction_RawData_Contract>[];
      json['contract'].forEach((v) {
        contract!.add(Transaction_RawData_Contract.fromJson(v));
      });
    }
    refBlockBytes = json['ref_block_bytes'];
    refBlockHash = json['ref_block_hash'];
    expiration = json['expiration'];
    timestamp = json['timestamp'];
    feeLimit = json['fee_limit'];
  }
}

class Transaction_RawData_Contract {
  Contract_Parameter? parameter;
  String? type;

  Transaction_RawData_Contract({this.parameter, this.type});

  Transaction_RawData_Contract.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'] != null ? Contract_Parameter.fromJson(json['parameter']) : null;
    type = json['type'];
  }
}

class Contract_Parameter {
  Contract_Parameter_Value? value;
  String? typeUrl;

  Contract_Parameter({this.value, this.typeUrl});

  Contract_Parameter.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? Contract_Parameter_Value.fromJson(json['value']) : null;
    typeUrl = json['type_url'];
  }
}

class Contract_Parameter_Value {
  int? amount;
  String? ownerAddress;
  String? toAddress;
  String? assetName;
  String? data;

  Contract_Parameter_Value({this.amount, this.ownerAddress, this.toAddress, this.assetName, this.data});

  Contract_Parameter_Value.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    ownerAddress = json['owner_address'];
    toAddress = json['to_address'];
    assetName = json['asset_name'];
    data = json['data'];
  }
}
