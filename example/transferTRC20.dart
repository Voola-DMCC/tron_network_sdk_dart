import 'package:tron_network_sdk/tron_network_sdk.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

final trc20abi = ContractAbi.fromJson(
    '[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]',
    'TRC20');
void main(List<String> args) async {
  var api = HTTPApiClient('http://54.252.224.209:8090');

  var m = '<mnemonic sentense>';
  var w = TronWallet.fromMnemonic(m);

  var transferFunc = trc20abi.functions.firstWhere((f) => f.name == 'transfer');
  var addr = TronWallet.tronAddressToEthAddress("TB99LXnWcpZ6gJB87NXGdfpUxXbvLY3iCs");
  var value = BigInt.from(100000);

  var preparedTx = await api.triggerConstantContract(
    contractAddress: "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t",
    functionSelector: transferFunc.encodeName(),
    encodedParamsHex: bytesToHex(transferFunc.encodeCall([addr, value]).sublist(4)),
    fromAddress: w.hexAddress,
    feeLimit: 100000000,
  );

  /// HOW TO ESTIMATE FEES:
  /// 1) put signature into prepared transaction
  preparedTx.transaction!.signature = [bytesToHex(w.signString(preparedTx.transaction!.txID!))];

  /// 2) transaction length in bytes == amount of BANDWIDTH resource will be used for confirmation
  print("BANDWIDTH: ${preparedTx.transaction!.getTxBytesLength()}");

  /// 3) because this is a contract call, it will consume ENERGY resource.
  print("ENERGY: ${preparedTx.energyUsed}");

  /// 4) amount of burned TRX depends on available BANDWIDTH and ENERGY on the account:
  ///
  /// resources of account = api.getAccountResource(address)
  ///

  var resp = await api.broadcastTransaction(
    txID: preparedTx.transaction!.txID!,
    rawDataJson: preparedTx.transaction!.rawDataJsonRaw!,
    rawDataHex: preparedTx.transaction!.rawDataHex!,
    signatures: preparedTx.transaction!.signature!,
  );

  print(resp.result);
  print(resp.txId);
}
