import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import { DEFAULT_REGION } from "../../env";

export const todoCreated = onDocumentCreated(
  { region: DEFAULT_REGION, document: "todos/{uid}/contents/{docId}" },
  (event) => {
    // Grab the current value of what was written to Firestore.
    const data = event.data?.data();

    // Access the parameter `{documentId}` with `event.params`
    logger.log("data: ", JSON.stringify(data));
    logger.log("params: ", event.params.uid, event.params.docId);
  }
);
