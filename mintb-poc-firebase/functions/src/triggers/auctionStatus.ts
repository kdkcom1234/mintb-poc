import { ethers } from 'ethers';
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { DEFAULT_REGION } from "../env";
import { db } from "..";
import { servicePrivateKey } from '../keys/privateKey';
import { mintbPocTokenABI, mintbPocTokenAddress } from '../offchain';

export const auctionStatusUpdated = onDocumentUpdated(
  {
    region: DEFAULT_REGION,
    document: "auctions/{auctionId}",
  },
  async (event) => {
    // logger.log("Hello--------");
    logger.log("params: ", event.params.auctionId);
    const { auctionId } = event.params;
    // logger.log("data: ", JSON.stringify(event.data));
    if (!event.data) {
      return;
    }

    const data = event.data.after.data();
    const status = data["status"] as number;
    logger.log("status:", status);

    // 경매에 대한 리워드 요청이면
    if (status == 2) {
      // 입찰 정보 조회
      const bidCol = await db.collection(`/auctions/${auctionId}/bids`)
        .orderBy("amount", "desc").get();
      const maxBidAmount = bidCol.docs[0].data()["amount"] as number;
      // 조회 정보 조회
      const viewCol = await db.collection(`/auctions/${auctionId}/views`).get();
      const viewCount = viewCol.docs.length;

      const mtbAmount = ((maxBidAmount / 1350.0).toFixed(4));
      const popAmount = maxBidAmount * 3 + viewCount * 10;

      // ---- 트랜잭션 생성 -----
      // 환경변수나 안전한 스토리지에서 비공개 키를 가져와야 합니다. 하드코딩은 위험합니다!
      const privateKey = servicePrivateKey;
      const tokenAddress = mintbPocTokenAddress;
      // 테스트주소 고정
      const toAddress = '0x98f32f758089ed9412eb8e2c560f4b94678c0d87';
      const amountToSend = ethers.parseUnits(mtbAmount, 'ether'); // BEP-20 토큰의 decimals에 따라 변경할 수 있습니다.

      // BNB Chain의 주소 및 ABI 세부 정보를 구성합니다.
      const bscTestnetUrl = 'https://data-seed-prebsc-1-s1.binance.org:8545/';
      const provider = new ethers.JsonRpcProvider(bscTestnetUrl);

      // 비공개 키를 사용하여 Signer 객체를 생성합니다.
      const wallet = new ethers.Wallet(privateKey, provider);

      // BEP-20 토큰의 ABI 세부 사항이 필요합니다. 일반적인 ERC-20 ABI를 사용할 수 있습니다.
      const tokenAbi = mintbPocTokenABI;

      // BEP-20 토큰의 컨트랙트 인스턴스를 생성합니다.
      const tokenContract = new ethers.Contract(tokenAddress, tokenAbi, wallet);

      // 토큰을 전송하고 트랜잭션 수신을 기다립니다.
      const tx = await tokenContract.transfer(toAddress, amountToSend);
      logger.log('Transaction hash:', tx.hash);

      // 트랜잭션 영수증을 기다립니다 (선택사항).
      const receipt = await tx.wait();
      logger.log('Transaction confirmed:', receipt);

      // ----- POP 점수 추가
      const pointDocRef = db.doc(`/points/${data["profileId"]}`);
      const point = await pointDocRef.get();
      const pointData = point.data();
      if (pointData) {
        const popCurrentScore = pointData["pop"] ? pointData["pop"] as number : 0;
        await pointDocRef.set({
          pop: popCurrentScore + popAmount
        }, { merge: true })
      } else {
        await pointDocRef.set({
          pop: popAmount
        })
      }

      // ----- 상태 변경(2 -> 3), 리워드 정보 추가 -----
      const auctionDocRef = db.doc(`/auctions/${auctionId}`);
      await auctionDocRef.set({
        status: 3,
        pop: popAmount,
        mint: maxBidAmount,
        mtb: +mtbAmount
      }, { merge: true });
    }
  }
);
