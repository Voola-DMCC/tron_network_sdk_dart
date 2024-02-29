class BroadcastResponse {
  bool? result;
  String? txId;

  BroadcastResponse({this.result, this.txId});

  BroadcastResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    txId = json['txid'];
  }
}
