import 'dart:convert';
import 'package:web3dart/crypto.dart';
import 'package:http/http.dart' as http;

import '../wallet/wallet.dart';
import 'models/account.dart';
import 'models/account_resource.dart';
import 'models/block.dart';
import 'models/broadcast_response.dart';
import 'models/contract_call_response.dart';
import 'models/contract_info.dart';
import 'models/transaction.dart';
import 'models/transaction_info.dart';
import 'models/validate_address.dart';

class HTTPApiClient {
  String endpoint;
  HTTPApiClient(this.endpoint);

  Future<dynamic> fetch(
    String path, {
    String method = 'GET',
    String? body,
    Map<String, String>? headers,
  }) async {
    var fullUrl = Uri.parse("$endpoint/$path");
    http.Response? resp;
    try {
      if (method == 'POST') {
        resp = await http.post(fullUrl, headers: headers, body: body);
      } else {
        resp = await http.get(fullUrl, headers: headers);
      }
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw "API Request code: ${resp.statusCode} \n body: ${resp.body}";
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

  String _checkHexAddr(String address) {
    if (TronWallet.isHexAddress(address)) {
      return address;
    } else {
      return TronWallet.bs58ToHexAddress(address);
    }
  }

  /// =========================== ACCOUNT ====================================
  //

  ///[address] should be in base58checksum, hexString, or base64 format.
  Future<ValidateAddressResp> validateAddress(String address) async {
    return ValidateAddressResp.fromJson(await fetch('wallet/validateaddress', method: 'POST', body: json.encode({'address': address})));
  }

  /// Query information about an account,Including balances, stake, votes and time, etc.
  Future<AccountResp> getAccount(String address) async {
    address = _checkHexAddr(address);
    return AccountResp.fromJson(await fetch('wallet/getaccount', method: 'POST', body: json.encode({'address': address})));
  }

  ///Query the resource information of an account(bandwidth,energy,etc)
  Future<AccountResourceResp> getAccountResource(String address) async {
    address = _checkHexAddr(address);
    return AccountResourceResp.fromJson(await fetch('wallet/getaccountresource', method: 'POST', body: json.encode({'address': address})));
  }

  ///Query bandwidth information.
  Future<AccountResourceResp> getAccountNet(String address) async {
    address = _checkHexAddr(address);
    return AccountResourceResp.fromJson(await fetch('wallet/getaccountnet', method: 'POST', body: json.encode({'address': address})));
  }

  /// ============================= NETWORK =================================
  //

  ///Query block header information or entire block information according to block height or block hash
  Future<Block> getBlock(String idOrNum, [bool detail = false]) async {
    return Block.fromJson(await fetch('wallet/getblock', method: 'POST', body: json.encode({'id_or_num': idOrNum, 'detail': detail})));
  }

  ///Returns the Block Object corresponding to the 'Block Height' specified (number of blocks preceding it).
  Future<Block> getBlockByNum(int blockNum) async {
    return Block.fromJson(await fetch('wallet/getblockbynum', method: 'POST', body: json.encode({'num': blockNum})));
  }

  ///Query block by ID(block hash).
  Future<Block> getBlockById(String id) async {
    return Block.fromJson(await fetch('wallet/getblockbyid', method: 'POST', body: json.encode({'value': id})));
  }

  ///Returns a list of block objects.
  ///
  ///[numberOfBLocks] - The number of blocks to query
  Future<List<Block>> getBlocksByLatestNum(int numberOfBlocks) async {
    return [
      for (var b in await fetch('wallet/getblockbylatestnum', method: 'POST', body: json.encode({'num': numberOfBlocks}))) Block.fromJson(b)
    ];
  }

  ///Returns the list of Block Objects included in the 'Block Height' range specified.
  ///
  ///[startNum] - Starting block height, including this block.
  ///
  ///[endNum] - Ending block height, excluding that block.
  Future<List<Block>> getBlocksByLimitNext(int startNum, int endNum) async {
    return [
      for (var b in await fetch('wallet/getblockbylimitnext', method: 'POST', body: json.encode({'startNum': startNum, 'endNum': endNum}))) Block.fromJson(b)
    ];
  }

  ///Query the latest block information
  Future<Block> getNowBlock() async {
    return Block.fromJson(await fetch('wallet/getnowblock', method: 'POST'));
  }

  ///Query the latest block information
  ///
  ///[id] - Transaction ID (hash)
  Future<Transaction> getTransactionById(String id) async {
    return Transaction.fromJson(await fetch('wallet/gettransactionbyid', method: 'POST', body: json.encode({'value': id})));
  }

  ///Query the transaction fee, block height by transaction id
  ///
  ///[id] - Transaction ID (hash)
  Future<TransactionInfo> getTransactionInfoById(String id) async {
    return TransactionInfo.fromJson(await fetch('wallet/gettransactioninfobyid', method: 'POST', body: json.encode({'value': id})));
  }

  ///Query historical energy unit price
  Future<String> getEnergyPrices() async {
    return (await fetch('wallet/getenergyprices'))['prices'];
  }

  ///Query historical energy unit price
  Future<String> getBandwidthPrices() async {
    return (await fetch('wallet/getbandwidthprices'))['prices'];
  }

  ///Get transaction list (list of hashes) information from pending pool
  Future<List<String>> getTransactionListFromPending() async {
    return (await fetch('wallet/gettransactionlistfrompending'))['txId'];
  }

  ///Get transaction details from the pending pool
  Future<Transaction> getTransactionFromPending(String id) async {
    return Transaction.fromJson(await fetch('wallet/gettransactionfrompending', method: 'POST', body: json.encode({'value': id})));
  }

  ///Get transaction details from the pending pool
  Future<int> getPendingSize(d) async {
    return (await fetch('wallet/getpendingsize'))['pendingSize'];
  }

  ///=========================== TRANSACTIONS =================================
  ///
  /// Create a TRX transfer transaction. If to_address does not exist, then create the account on the blockchain.
  ///
  /// [from] - sender address
  ///
  /// [to] - target address
  ///
  /// [amount] - Amount is the transfer amount,the unit is sun
  ///
  /// [permissionId] - Optional, for multi-signature use
  ///
  /// [extraData] - Optional, totes on the transaction, HEX format
  ///
  Future<Transaction> createTransaction({
    required String from,
    required String to,
    required int amount,
    int? permissionId,
    String? extraData,
  }) async {
    from = _checkHexAddr(from);
    to = _checkHexAddr(to);

    var txBody = {
      "to_address": to,
      "owner_address": from,
      "amount": amount,
    };
    if (permissionId != null) txBody["permission_id"] = permissionId;
    if (extraData != null) txBody["extra_data"] = extraData;
    return Transaction.fromJson(await fetch('wallet/createtransaction', method: 'POST', body: json.encode(txBody)));
  }

  /// Broadcast signed transaction
  ///
  /// obtain parameters for call from [createTransaction] or [triggerSmartContract] method;
  ///
  Future<BroadcastResponse> broadcastTransaction({
    required String txID,
    required String rawDataJson,
    required String rawDataHex,
    required List<String> signatures,
  }) async {
    signatures = signatures.map((e) {
      if (!e.startsWith('0x'))
        return '0x$e';
      else
        return e;
    }).toList();
    final body = {
      "txID": txID,
      "raw_data": rawDataJson,
      "raw_data_hex": rawDataHex,
      "signature": signatures,
    };
    return BroadcastResponse.fromJson(await fetch('wallet/broadcasttransaction', method: 'POST', body: json.encode(body)));
  }

  /// Send some TRX amount
  ///
  /// This method creates, signs and sends a transaction.
  ///
  Future<BroadcastResponse> sendTrx({
    required TronWallet from,
    required String to,
    required int amount,
    int? permissionId,
  }) async {
    final tx = await createTransaction(from: from.hexAddress, to: to, amount: amount);

    final signature = bytesToHex(from.signString(tx.txID!));
    return await broadcastTransaction(txID: tx.txID!, rawDataJson: tx.rawDataJsonRaw!, rawDataHex: tx.rawDataHex!, signatures: ['0x$signature']);
  }

  /// ===================================== SMART-CONTRACTS===================
  ///
  ///
  ///Queries a contract's information from the blockchain, including the bytecode of the contract, ABI, configuration parameters, etc.
  Future<ContractInfoResp> getContract({
    required String contractAddress,
  }) async {
    contractAddress = _checkHexAddr(contractAddress);

    return ContractInfoResp.fromJson(await fetch('wallet/broadcasttransaction', method: 'POST', body: json.encode({'value': contractAddress})));
  }

  /// Invoke the readonly function (modified by the view or pure modifier)
  /// of a contract for contract data query; or Invoke the non-readonly function
  /// of a contract for predicting whether the transaction can be successfully
  /// executed or estimating the energy consumption
  ///
  /// [contractAddress]  - smart contract address
  ///
  /// [functionSelector] - called function signature
  ///
  /// [encodedParamsHex] - encoded called function parameters in hex string
  ///
  /// [fromAddress] - caller`s address
  ///
  Future<ContractCallResponse> triggerConstantContract({
    required String contractAddress,
    required String functionSelector,
    required String encodedParamsHex,
    required String fromAddress,
    int? feeLimit,
  }) async {
    contractAddress = _checkHexAddr(contractAddress);
    fromAddress = _checkHexAddr(fromAddress);
    final body = {
      "owner_address": fromAddress,
      "contract_address": contractAddress,
      "function_selector": functionSelector,
      if (feeLimit != null) "fee_limit": feeLimit,
      "parameter": encodedParamsHex,
    };
    return ContractCallResponse.fromJson(await fetch('wallet/triggerconstantcontract', method: 'POST', body: json.encode(body)));
  }

  /// Trigger smart-contract method that requires transaction sending.
  ///
  /// Returns TransactionExtention, which contains the unsigned Transaction. For send - call broadcast.
  ///
  /// [contractAddress]  - smart contract address
  ///
  /// [functionSelector] - called function signature
  ///
  /// [encodedParamsHex] - encoded called function parameters in hex string
  ///
  /// [callValue] - Amount of TRX transferred with this transaction, measured in SUN (1 TRX = 1,000,000 SUN).
  ///
  /// [feeLimit] - Maximum TRX consumption, measured in SUN (1 TRX = 1,000,000 SUN).
  ///
  /// [fromAddress] - caller`s address
  ///
  /// [permissionId] - Optional, for multi-signature
  ///
  Future<ContractCallResponse> triggerSmartContract({
    required String contractAddress,
    required String functionSelector,
    required String encodedParamsHex,
    int? callValue = 0,
    required int feeLimit,
    required String fromAddress,
    int? permissionId,
  }) async {
    contractAddress = _checkHexAddr(contractAddress);
    fromAddress = _checkHexAddr(fromAddress);

    final body = {
      "owner_address": fromAddress,
      "contract_address": contractAddress,
      "function_selector": functionSelector,
      "parameter": encodedParamsHex,
      "fee_limit": feeLimit,
      "call_value": callValue,
      if (permissionId != null) "permission_id": permissionId,
    };

    return ContractCallResponse.fromJson(await fetch('wallet/triggersmartcontract', method: 'POST', body: json.encode(body)));
  }
}
