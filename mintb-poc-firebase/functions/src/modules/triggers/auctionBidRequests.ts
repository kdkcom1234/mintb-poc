import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { DEFAULT_REGION } from "../../env";

import * as admin from "firebase-admin";

export const auctionBidRequestsCreated = onDocumentCreated(
  {
    region: DEFAULT_REGION,
    document: "auctions/{auctionId}/bid-requests/{uid}",
  },
  async (event) => {
    // Grab the current value of what was written to Firestore.
    const data = event.data?.data();

    // Access the parameter `{documentId}` with `event.params`
    logger.log("data: ", JSON.stringify(data));
    logger.log("params: ", event.params.uid, event.params.auctionId);
  }
);
