import 'dart:typed_data';

import 'package:tron_network_sdk/src/http_api/http_api.dart';
import 'package:tron_network_sdk/src/wallet/wallet.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as w3;
import 'package:http/http.dart';

final trc20abi = w3.ContractAbi.fromJson(
    '[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]',
    'TRC20');
final multicallAbi = w3.ContractAbi.fromJson(
    '[{"outputs":[{"name":"blockNumber","type":"uint256"},{"name":"returnData","type":"bytes[]"}],"inputs":[{"name":"target","type":"address[]"},{"name":"callData","type":"bytes[]"}],"name":"aggregate","stateMutability":"view","type":"function"},{"outputs":[{"name":"returnData","type":"bytes"}],"inputs":[{"name":"target","type":"address"},{"name":"data","type":"bytes"}],"name":"callIt","stateMutability":"view","type":"function"},{"outputs":[{"name":"balance","type":"uint256"}],"inputs":[{"name":"addr","type":"address"}],"name":"getBalance","stateMutability":"view","type":"function"},{"outputs":[{"name":"blockHash","type":"bytes32"}],"inputs":[{"name":"blockNumber","type":"uint256"}],"name":"getBlockHash","stateMutability":"view","type":"function"},{"outputs":[{"name":"coinbase","type":"address"}],"name":"getCurrentBlockCoinbase","stateMutability":"view","type":"function"},{"outputs":[{"name":"timestamp","type":"uint256"}],"name":"getCurrentBlockTimestamp","stateMutability":"view","type":"function"},{"outputs":[{"name":"blockHash","type":"bytes32"}],"name":"getLastBlockHash","stateMutability":"view","type":"function"}]',
    'Multicall');
var provider = w3.Web3Client("http://34.237.210.82:8091/jsonrpc", Client());

void main(List<String> args) async {
  var api = HTTPApiClient('http://3.225.171.164:8090');

  ///for TRX balance query
  var multicallAddr = TronWallet.tronAddressToEthAddress("TJ9Tcdpe3UM8DGXbyXDkUmhiPu14psfcaz");

  var tokens = [
    TronWallet.tronAddressToEthAddress("TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"),
    TronWallet.tronAddressToEthAddress("TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8"),
  ];
  var addresses = [
    TronWallet.tronAddressToEthAddress("TYE218dMfzo2TH348AbKyHD2G8PjGo7ESS"),
    TronWallet.tronAddressToEthAddress("TK2ZcTKE4k4wPuAXHkyX4Y4uckaqRpKHne"),
  ];
  var balOfFunc = trc20abi.functions.firstWhere((element) => element.name == 'balanceOf');
  final getTrxBalanceFunction = multicallAbi.functions.firstWhere((f) => f.name == 'getBalance');

  var param1 = [];
  for (var element in List.filled(addresses.length, [multicallAddr, ...tokens])) {
    param1.addAll(element);
  }

  var param2 = [];

  for (var addr in addresses) {
    param2.addAll([
      getTrxBalanceFunction.encodeCall([addr]),
      ...List.filled(tokens.length, balOfFunc.encodeCall([addr])),
    ]);
  }

  var aggFunc = multicallAbi.functions.firstWhere((f) => f.name == 'aggregate');
  var encodedParamsHex = bytesToHex(aggFunc.encodeCall([param1, param2]).sublist(4));
  var resp = await api.triggerConstantContract(
    contractAddress: "TJ9Tcdpe3UM8DGXbyXDkUmhiPu14psfcaz",
    functionSelector: aggFunc.encodeName(),
    encodedParamsHex: encodedParamsHex,
    fromAddress: TronWallet.bs58ToHexAddress('TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t'),
  );
  var result1 = resp.constantResult!;
  var decodedResult1 = aggFunc.decodeReturnValues(result1.first);
  print(decodedResult1);
  final result = (decodedResult1[1] as List<dynamic>).cast<Uint8List>().map((e) => w3.EtherAmount.inWei(bytesToInt(e)));
  for (var i in result) {
    print(i.getInWei);
  }
}
