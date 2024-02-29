class TransactionInfo {
  String? id;
  int? fee;
  int? blockNumber;
  int? blockTimeStamp;
  List<String>? contractResult;
  String? contractAddress;
  TransactionInfo_Receipt? receipt;
  List<TransactionInfo_Log>? log;

  TransactionInfo({this.id, this.fee, this.blockNumber, this.blockTimeStamp, this.contractResult, this.contractAddress, this.receipt, this.log});

  TransactionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fee = json['fee'];
    blockNumber = json['blockNumber'];
    blockTimeStamp = json['blockTimeStamp'];
    contractResult = json['contractResult'].cast<String>();
    contractAddress = json['contract_address'];
    receipt = json['receipt'] != null ? TransactionInfo_Receipt.fromJson(json['receipt']) : null;
    if (json['log'] != null) {
      log = <TransactionInfo_Log>[];
      json['log'].forEach((v) {
        log!.add(TransactionInfo_Log.fromJson(v));
      });
    }
  }
}

class TransactionInfo_Receipt {
  int? energyFee;
  int? energyUsageTotal;
  int? netUsage;
  String? result;

  TransactionInfo_Receipt({this.energyFee, this.energyUsageTotal, this.netUsage, this.result});

  TransactionInfo_Receipt.fromJson(Map<String, dynamic> json) {
    energyFee = json['energy_fee'];
    energyUsageTotal = json['energy_usage_total'];
    netUsage = json['net_usage'];
    result = json['result'];
  }
}

class TransactionInfo_Log {
  String? address;
  List<String>? topics;
  String? data;

  TransactionInfo_Log({this.address, this.topics, this.data});

  TransactionInfo_Log.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    topics = json['topics'].cast<String>();
    data = json['data'];
  }
}
