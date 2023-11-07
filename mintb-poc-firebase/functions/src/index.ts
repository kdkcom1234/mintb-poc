import * as admin from "firebase-admin";

admin.initializeApp();
export const db = admin.firestore();

export { auctionBidRequestsCreated } from "./triggers/auctionBidRequests";
export { auctionRequestsUpdated } from "./triggers/auctionRequests";
export { auctionStatusUpdated } from "./triggers/auctionStatus";
// export { todoCreated } from "./modules/triggers/todo";