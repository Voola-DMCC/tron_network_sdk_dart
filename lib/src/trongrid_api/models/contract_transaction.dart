import 'response_meta.dart';

class TGridTRCTransactionResp {
  List<TGridTRCTransaction>? data;
  bool? success;
  TGridRespMeta? meta;

  TGridTRCTransactionResp({this.data, this.success, this.meta});

  TGridTRCTransactionResp.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TGridTRCTransaction>[];
      json['data'].forEach((v) {
        data!.add(TGridTRCTransaction.fromJson(v));
      });
    }
    success = json['success'];
    meta = json['meta'] != null ? TGridRespMeta.fromJson(json['meta']) : null;
  }
}

class TGridTRCTransaction {
  String? transactionId;
  TGridTRCTransactionTokenInfo? tokenInfo;
  int? blockTimestamp;
  String? from;
  String? to;
  String? type;
  String? value;

  TGridTRCTransaction({this.transactionId, this.tokenInfo, this.blockTimestamp, this.from, this.to, this.type, this.value});

  TGridTRCTransaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    tokenInfo = json['token_info'] != null ? TGridTRCTransactionTokenInfo.fromJson(json['token_info']) : null;
    blockTimestamp = json['block_timestamp'];
    from = json['from'];
    to = json['to'];
    type = json['type'];
    value = json['value'];
  }
}

class TGridTRCTransactionTokenInfo {
  String? symbol;
  String? address;
  int? decimals;
  String? name;

  TGridTRCTransactionTokenInfo({this.symbol, this.address, this.decimals, this.name});

  TGridTRCTransactionTokenInfo.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    address = json['address'];
    decimals = json['decimals'];
    name = json['name'];
  }
}
