import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { DEFAULT_REGION } from "../env";
import { db } from "..";

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

      // 상태 변경(2 -> 3)
      // 리워드 정보 추가
      const auctionDocRef = db.doc(`/auctions/${auctionId}`);
      await auctionDocRef.set({
        status: 3,
        pop: maxBidAmount * 3 + viewCount * 10,
        mint: maxBidAmount,
        mtb: +((maxBidAmount / 1350.0).toFixed(4))
      }, { merge: true });
    }
  }
);
