import 'transaction.dart';

class ContractCallResponse {
  bool? result;
  int? energyUsed;
  List<String>? constantResult;
  Transaction? transaction;
  List<InternalTransaction>? internalTransactions;

  ContractCallResponse({this.result, this.energyUsed, this.constantResult, this.transaction, this.internalTransactions});

  ContractCallResponse.fromJson(Map<String, dynamic> json) {
    result = json['result']['result'];
    energyUsed = json['energy_used'];
    if (json['constant_result'] != null) constantResult = json['constant_result'].cast<String>();
    transaction = json['transaction'] != null ? Transaction.fromJson(json['transaction']) : null;
    if (json['internal_transactions'] != null) {
      internalTransactions = <InternalTransaction>[];
      json['internal_transactions'].forEach((v) {
        internalTransactions!.add(InternalTransaction.fromJson(v));
      });
    }
  }
}

class InternalTransaction {
  String? callerAddress;
  String? note;
  String? transferToAddress;
  List<Map<String, dynamic>>? callValueInfo;
  String? hash;

  InternalTransaction({this.callerAddress, this.note, this.transferToAddress, this.callValueInfo, this.hash});

  InternalTransaction.fromJson(Map<String, dynamic> json) {
    callerAddress = json['caller_address'];
    note = json['note'];
    transferToAddress = json['transferTo_address'];
    callValueInfo = (json['callValueInfo'] as List).cast<Map<String, dynamic>>();
    hash = json['hash'];
  }
}
