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

      const doc = await db.doc(`/points/${event.params.uid}`).get();
      const pointData = doc.data();
      if (pointData) {
        logger.log("pointData: ", JSON.stringify(pointData));

        const point = pointData["mint"] as number;
        logger.log(`amount: ${amount} point: ${point}`);

        if (point >= amount) {
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

          // 입찰 요청정보 삭제
          const bidReqDocRef =
            db.doc("/auctions" +
              `/${event.params.auctionId}/bid-requests/${event.params.uid}`);
          await bidReqDocRef.delete();
        }
      }
    }
  }
);
