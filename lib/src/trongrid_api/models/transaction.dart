import 'response_meta.dart';

class TGridTransactionsResp {
  List<TGridTransaction>? data;
  bool? success;
  TGridRespMeta? meta;

  TGridTransactionsResp({this.data, this.success, this.meta});

  TGridTransactionsResp.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = json['data'].map<TGridTransaction>((e) => TGridTransaction.fromJson(e)).toList();
    }
    success = json['success'];
    meta = json['meta'] != null ? TGridRespMeta.fromJson(json['meta']) : null;
  }
}

class TGridTransaction {
  List<TGridTxRet>? ret;
  List<String>? signature;
  String? txID;
  int? netUsage;
  String? rawDataHex;
  int? netFee;
  int? energyUsage;
  int? blockNumber;
  int? blockTimestamp;
  int? energyFee;
  int? energyUsageTotal;
  TGridTxRawData? rawData;
  List<dynamic>? internalTransactions;

  TGridTransaction(
      {this.ret,
      this.signature,
      this.txID,
      this.netUsage,
      this.rawDataHex,
      this.netFee,
      this.energyUsage,
      this.blockNumber,
      this.blockTimestamp,
      this.energyFee,
      this.energyUsageTotal,
      this.rawData,
      this.internalTransactions});

  TGridTransaction.fromJson(Map<String, dynamic> json) {
    if (json['ret'] != null) {
      ret = <TGridTxRet>[];
      json['ret'].forEach((v) {
        ret!.add(TGridTxRet.fromJson(v));
      });
    }
    signature = json['signature'].cast<String>();
    txID = json['txID'];
    netUsage = json['net_usage'];
    rawDataHex = json['raw_data_hex'];
    netFee = json['net_fee'];
    energyUsage = json['energy_usage'];
    blockNumber = json['blockNumber'];
    blockTimestamp = json['block_timestamp'];
    energyFee = json['energy_fee'];
    energyUsageTotal = json['energy_usage_total'];
    rawData = json['raw_data'] != null ? TGridTxRawData.fromJson(json['raw_data']) : null;
    internalTransactions = json['internal_transactions'];
  }
}

class TGridTxRet {
  String? contractRet;
  int? fee;

  TGridTxRet({this.contractRet, this.fee});

  TGridTxRet.fromJson(Map<String, dynamic> json) {
    contractRet = json['contractRet'];
    fee = json['fee'];
  }
}

class TGridTxRawData {
  List<TGridTxRawDataContract>? contract;
  String? refBlockBytes;
  String? refBlockHash;
  int? expiration;
  int? timestamp;
  String? data;

  TGridTxRawData({this.contract, this.refBlockBytes, this.refBlockHash, this.expiration, this.timestamp, this.data});

  TGridTxRawData.fromJson(Map<String, dynamic> json) {
    if (json['contract'] != null) {
      contract = <TGridTxRawDataContract>[];
      json['contract'].forEach((v) {
        contract!.add(TGridTxRawDataContract.fromJson(v));
      });
    }
    refBlockBytes = json['ref_block_bytes'];
    refBlockHash = json['ref_block_hash'];
    expiration = json['expiration'];
    timestamp = json['timestamp'];
    data = json['data'];
  }
}

class TGridTxRawDataContract {
  TGridTxRawDataContractParameter? parameter;
  String? type;

  TGridTxRawDataContract({this.parameter, this.type});

  TGridTxRawDataContract.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'] != null ? TGridTxRawDataContractParameter.fromJson(json['parameter']) : null;
    type = json['type'];
  }
}

class TGridTxRawDataContractParameter {
  TGridTxRawDataContractParameterValue? value;
  String? typeUrl;

  TGridTxRawDataContractParameter({this.value, this.typeUrl});

  TGridTxRawDataContractParameter.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? TGridTxRawDataContractParameterValue.fromJson(json['value']) : null;
    typeUrl = json['type_url'];
  }
}

class TGridTxRawDataContractParameterValue {
  int? amount;
  String? ownerAddress;
  String? toAddress;

  TGridTxRawDataContractParameterValue({this.amount, this.ownerAddress, this.toAddress});

  TGridTxRawDataContractParameterValue.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    ownerAddress = json['owner_address'];
    toAddress = json['to_address'];
  }
}
