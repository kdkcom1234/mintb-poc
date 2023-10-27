import 'dart:developer' as dev;
import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mintb_poc_app/keys/private_key.dart';
import 'package:web3dart/web3dart.dart';

import 'mintb_poc_token.dart';

const chainId = 97;

Web3Client _web3Client() {
  // Binance Smart Chain 테스트넷 URL
  return Web3Client(
    'https://data-seed-prebsc-1-s1.binance.org:8545/',
    http.Client(),
  );
}

EthPrivateKey _credentials() {
  return EthPrivateKey.fromHex(testPrivateKey);
}

DeployedContract _tokenContract() {
  return DeployedContract(ContractAbi.fromJson(mintbPocTokenABI, 'BEP20Token'),
      EthereumAddress.fromHex(mintbPocTokenAddress));
}

ContractFunction _tokenBalanceOf() {
  return _tokenContract().function('balanceOf');
}

ContractFunction _tokenTransfer() {
  return _tokenContract().function('transfer');
}

EthereumAddress walletAddress() {
  return _credentials().address;
}

BigInt _parseToBigInt(String valueStr, int decimals) {
  int pointIndex = valueStr.indexOf('.');
  if (pointIndex == -1) {
    // 소수점이 없는 경우
    return BigInt.parse(valueStr) * BigInt.from(pow(10, decimals));
  }

  // 소숫점 이후의 숫자 개수 계산
  int numDecimals = valueStr.length - pointIndex - 1;

  if (numDecimals > decimals) {
    throw const FormatException('Value has more decimals than expected.');
  }

  // 소수점 제거
  String withoutPoint = valueStr.replaceAll('.', '');

  return BigInt.parse(withoutPoint) *
      BigInt.from(pow(10, decimals - numDecimals));
}

Future<String> getNativeBalance() async {
  // 네이티브 코인 밸런스 조회
  final nativeBalance = await _web3Client().getBalance(walletAddress());
  // log('BNB Balance: ${nativeBalance.getValueInUnit(EtherUnit.ether)}');
  return nativeBalance.getValueInUnit(EtherUnit.ether).toString();
}

Future<String> getTokenBalance() async {
  // BEP-20 토큰 밸런스 조회
  final tokenBalance = await _web3Client().call(
      contract: _tokenContract(),
      function: _tokenBalanceOf(),
      params: [walletAddress()]);
  final tokenBalanceAmount =
      EtherAmount.fromBigInt(EtherUnit.wei, tokenBalance.first as BigInt);

  // log('BEP-20 Token Balance: ${tokenBalanceAmount.getValueInUnit(EtherUnit.ether)}');
  return tokenBalanceAmount.getValueInUnit(EtherUnit.ether).toString();
}

Future<String> getEstimatedGas(String toAddress, String tokenAmount) async {
  // 예상되는 수신자 및 금액 설정
  final receiverAddress = EthereumAddress.fromHex(toAddress);
  final data = _tokenTransfer()
      .encodeCall([receiverAddress, _parseToBigInt(tokenAmount, 18)]);

  var gasEstimated = await _web3Client().estimateGas(
    sender: walletAddress(),
    to: receiverAddress,
    data: data,
  );

  dev.log(gasEstimated.toString());

  final amount = EtherAmount.fromBigInt(EtherUnit.wei, gasEstimated);
  return amount.getValueInUnit(EtherUnit.ether).toString();
}

Future<void> transferTokens(String toAddress, String tokenAmount) async {
  final receiverAddress = EthereumAddress.fromHex(toAddress);

  // 트랜잭션 준비
  var tx = Transaction.callContract(
    contract: _tokenContract(),
    function: _tokenTransfer(),
    parameters: [receiverAddress, _parseToBigInt(tokenAmount, 18)],
  );

  try {
    // 트랜잭션 전송 및 영수증 수신
    var result = await _web3Client()
        .sendTransaction(_credentials(), tx, chainId: chainId);

    dev.log('Transaction hash: $result');
    Fluttertoast.showToast(msg: 'SUCCESS: $result');
  } catch (e) {
    Fluttertoast.showToast(msg: 'FAILED: ${e.toString()}');
  }
}

bool isValidEthereumAddress(String address) {
  try {
    EthereumAddress.fromHex(address);
    return true;
  } catch (e) {
    return false;
  }
}
