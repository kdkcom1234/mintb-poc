import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { DEFAULT_REGION } from "../env";

import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";

admin.initializeApp();
const db = admin.firestore();

export const auctionBidRequestsCreated = onDocumentCreated(
  {
    region: DEFAULT_REGION,
    document: "auctions/{auctionId}/bid-requests/{uid}",
  },
  async (event) => {
    // logger.log("Hello--------");
    logger.log("params: ", event.params.uid, event.params.auctionId);
    const { uid, auctionId } = event.params;

    const data = event.data?.data();
    if (!data) {
      return;
    }

    logger.log("data: ", JSON.stringify(data));
    const amount = data["amount"] as number;

    // 1. 이전 최상위 입찰보다 amount가 커야됨
    const bidCol = await db.collection(`/auctions/${auctionId}/bids`)
      .orderBy("amount", "desc").limit(1).get();
    logger.log("bidCol: ", JSON.stringify(bidCol.docs));
    if (bidCol.docs.length > 0) {
      const maxBidData = bidCol.docs[0].data();
      const maxBidAmount = maxBidData["amount"] as number;

      if (amount < maxBidAmount) {
        return; // confirm = false;
      }
    }

    // 2. 포인트가 존재하고, 입찰수량이 보유포인트 보다 작은지 체크
    const pointDoc = await db.doc(`/points/${uid}`).get();
    const pointData = pointDoc.data();
    logger.log("pointData: ", JSON.stringify(pointData));
    // 포인트 데이터가 없으면 종료
    if (!pointData) {
      return; // confirm: false
    }

    const point = pointData["mint"] as number;
    logger.log(`amount: ${amount} point: ${point}`);

    // 입찰수량이 보유 포인트 보다 크면 종료
    if (amount > point) {
      return; // confirm: false
    }

    // 입찰 등록
    const bidDocRef = db.doc(`/auctions/${auctionId}/bids/${uid}`);
    await bidDocRef.set({
      amount,
      createdAt: FieldValue.serverTimestamp(),
    });

    // 포인트 차감
    const decreasedPoint = point - amount;
    const pointDocRef = db.doc(`/points/${uid}`);
    await pointDocRef.set({ mint: decreasedPoint });

    // 입찰 요청정보 삭제(임시)
    // TODO: 입찰이 완료되면 요청정보는 confirm = true로 바뀜
    // TODO:
    // rules에 allow create: if request.resource.confirm == false
    // 초기생성에는 false로 시작
    const bidReqDocRef = db.doc(`/auctions/${auctionId}/bid-requests/${uid}`);
    await bidReqDocRef.delete();
  }
);
