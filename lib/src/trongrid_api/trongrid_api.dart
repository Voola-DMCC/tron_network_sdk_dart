import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tron_network_sdk/src/trongrid_api/models/account_info.dart';
import 'package:tron_network_sdk/src/trongrid_api/models/contract_transaction.dart';
import 'package:tron_network_sdk/src/trongrid_api/models/transaction.dart';

class TrongridApiClient {
  String endpoint;

  ///https://developers.tron.network/reference/select-network
  String? apiKey;
  TrongridApiClient(this.endpoint, [this.apiKey]);

  Future<dynamic> fetch(
    String path, {
    String method = 'GET',
    String? body,
    Map<String, String>? headers,
  }) async {
    var fullUrl = Uri.parse("$endpoint/$path");
    if (apiKey != null) {
      if (headers != null) {
        headers['TRON-PRO-API-KEY'] = apiKey!;
      } else {
        headers = {'TRON-PRO-API-KEY': apiKey!};
      }
    }
    http.Response? resp;
    try {
      if (method == 'POST') {
        resp = await http.post(fullUrl, headers: headers, body: body);
      } else {
        resp = await http.get(fullUrl, headers: headers);
      }
      print("=======================");
      print(resp.statusCode);
      print(resp.body);
      print("=======================");

      return json.decode(resp.body);
    } catch (e) {
      rethrow;
    }
  }

  /// https://developers.tron.network/reference/get-account-info-by-address
  Future<TGridAccountInfo> accountInfo(
    String address, {
    bool? onlyConfirmed,
    bool? onlyUnonfirmed,
  }) async {
    var args = [
      if (onlyConfirmed != null) 'only_confirmed=$onlyConfirmed',
      if (onlyUnonfirmed != null) 'only_unonfirmed=$onlyUnonfirmed',
    ];
    return TGridAccountInfo.fromJson(await fetch('v1/accounts/$address?${args.join('&')}'));
  }

  /// https://developers.tron.network/reference/get-transaction-info-by-account-address
  Future<TGridTransactionsResp> accountTransactions(
    String address, {
    bool? onlyConfirmed,
    bool? onlyUnonfirmed,
    bool? onlyTo,
    bool? onlyFrom,
    int? limit,
    String? fingerprint,
    String? orderBy,
    int? minTimestamp,
    int? maxTimestamp,
    bool? searchInternal,
  }) async {
    var args = [
      if (onlyConfirmed != null) 'only_confirmed=$onlyConfirmed',
      if (onlyUnonfirmed != null) 'only_unonfirmed=$onlyUnonfirmed',
      if (onlyTo != null) 'only_to=$onlyTo',
      if (onlyFrom != null) 'only_from=$onlyFrom',
      if (limit != null) 'limit=$limit',
      if (fingerprint != null) 'fingerprint=$fingerprint',
      if (orderBy != null) 'order_by=$orderBy',
      if (minTimestamp != null) 'min_timestamp=$minTimestamp',
      if (maxTimestamp != null) 'max_timestamp=$maxTimestamp',
      if (searchInternal != null) 'search_internal=$searchInternal',
    ];
    return TGridTransactionsResp.fromJson(await fetch('v1/accounts/$address/transactions?${args.join('&')}'));
  }

  /// https://developers.tron.network/reference/get-trc20-transaction-info-by-account-address
  Future<TGridTRCTransactionResp> accountTransactionsTRC(
    String address, {
    String? contractAddress,
    bool? onlyConfirmed,
    bool? onlyUnonfirmed,
    bool? onlyTo,
    bool? onlyFrom,
    int? limit,
    String? fingerprint,
    String? orderBy,
    int? minTimestamp,
    int? maxTimestamp,
    bool? searchInternal,
  }) async {
    var args = [
      if (contractAddress != null) 'contract_address=$contractAddress',
      if (onlyConfirmed != null) 'only_confirmed=$onlyConfirmed',
      if (onlyUnonfirmed != null) 'only_unonfirmed=$onlyUnonfirmed',
      if (onlyTo != null) 'only_to=$onlyTo',
      if (onlyFrom != null) 'only_from=$onlyFrom',
      if (limit != null) 'limit=$limit',
      if (fingerprint != null) 'fingerprint=$fingerprint',
      if (orderBy != null) 'order_by=$orderBy',
      if (minTimestamp != null) 'min_timestamp=$minTimestamp',
      if (maxTimestamp != null) 'max_timestamp=$maxTimestamp',
      if (searchInternal != null) 'search_internal=$searchInternal',
    ];
    return TGridTRCTransactionResp.fromJson(await fetch('v1/accounts/$address/transactions/trc20?${args.join('&')}'));
  }
}
