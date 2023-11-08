import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { DEFAULT_REGION } from "../env";
import { db } from "../admin";
import { FieldValue } from "firebase-admin/firestore";

export const auctionRequestsUpdated = onDocumentUpdated(
  {
    region: DEFAULT_REGION,
    document: "auction-requests/{auctionRequestId}",
  },
  async (event) => {
    // logger.log("Hello--------");
    logger.log("params: ", event.params.auctionRequestId);
    const { auctionRequestId } = event.params;
    // logger.log("data: ", JSON.stringify(event.data));
    if (!event.data) {
      return;
    }

    const data = event.data.after.data();
    const isLive = data["isLive"] as boolean;
    logger.log("isLive:", isLive);

    // 경매를 시작하면 라이브 경매 컬렉션에 추가
    if (isLive) {
      // 현재 시각을 가져온 후 24시간을 더합니다. (30초 빼고)
      const now = new Date().getTime();
      const oneDayLater = new Date(now + 24 * 60 * 60 * 1000 - 30 * 1000);
      const colRef = db.collection("/auctions");
      await colRef.add({
        profileId: data["profileId"],
        auctionRequestId,
        createdAt: FieldValue.serverTimestamp(),
        duration: oneDayLater,
        isLive: true,
      });
    }
  }
);
