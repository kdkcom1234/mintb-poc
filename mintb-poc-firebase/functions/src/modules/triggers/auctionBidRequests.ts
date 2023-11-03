import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { DEFAULT_REGION } from "../../env";

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
    logger.log("params: ", event.params.uid, event.params.auctionId);

    // Grab the current value of what was written to Firestore.
    const data = event.data?.data();
    if (data) {
      logger.log("data: ", JSON.stringify(data));

      const amount = data["amount"] as number;

      // TODO: 이전 최상위 입찰보다 amount가 커야되는 로직 추가해야함

      // 포인트가 존재하고, 입찰수량이 보유포인트 보다 작은지 체크
      const doc = await db.doc(`/points/${event.params.uid}`).get();
      const pointData = doc.data();
      let point = 0;

      if (!pointData) {
        return; // confirm: false
      } else {
        logger.log("pointData: ", JSON.stringify(pointData));

        point = pointData["mint"] as number;
        logger.log(`amount: ${amount} point: ${point}`);

        // 입찰수량이 보유 포인트 보다 크면 종료
        if (amount > point) {
          return; // confirm: false
        }
      }

      // 입찰 등록
      const bidDocRef =
        db.doc("/auctions/" +
          `${event.params.auctionId}/bids/${event.params.uid}`);
      await bidDocRef.set({
        amount,
        createdAt: FieldValue.serverTimestamp(),
      });

      // 포인트 차감
      const decreasedPoint = point - amount;
      const pointDocRef = db.doc(`/points/${event.params.uid}`);
      await pointDocRef.set({ mint: decreasedPoint });

      // 입찰 요청정보 삭제(임시)
      // TODO: 입찰이 완료되면 요청정보는 confirm = true로 바뀜
      // TODO: rules에 allow create: if request.resource.confirm == false 로 초기생성에는 false로 시작
      const bidReqDocRef =
        db.doc("/auctions" +
          `/${event.params.auctionId}/bid-requests/${event.params.uid}`);
      await bidReqDocRef.delete();
    }
  }
);
