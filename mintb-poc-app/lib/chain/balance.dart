import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

import 'mintb_poc_token.dart';

Future<void> getBalance() async {
  final client = Web3Client(
    'https://data-seed-prebsc-1-s1.binance.org:8545/', // Binance Smart Chain 테스트넷 URL
    http.Client(),
  );

  final privateKey =
      EthPrivateKey.fromHex('YOUR_PRIVATE_KEY_HERE'); // 본인의 Private Key로 교체
  final address = privateKey.address;

  // 네이티브 코인 밸런스 조회
  EtherAmount nativeBalance = await client.getBalance(address);

  log('BNB Balance: ${nativeBalance.getInEther}');

  // BEP-20 토큰 밸런스 조회
  final tokenContractAddress = EthereumAddress.fromHex(mintbPocTokenAddress);
  final tokenContract = DeployedContract(
      ContractAbi.fromJson(mintbPocTokenAPI, 'BEP20Token'),
      tokenContractAddress);

  final balanceFunction = tokenContract.function('balanceOf');
  final tokenBalance = await client.call(
      contract: tokenContract, function: balanceFunction, params: [address]);

  log('BEP-20 Token Balance: ${tokenBalance.first}');
}
