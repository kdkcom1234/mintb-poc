import { Router as router } from "express";
import { logger } from "firebase-functions/v2";
import { RequestWithUser } from "../../middleware/auth";
import { db } from "../../../admin";

const points = router();
points.post("/mint/purchase", async (req: RequestWithUser, res) => {
  logger.log(req.headers.authorization);
  logger.log(req.user?.uid);
  logger.log(req.body);

  const amount = parseInt(req.body["amount"]);
  if (!amount) {
    res.status(400).send("amount is required");
  }

  const pointDocRef = db.doc(`/points/${req.user?.uid}`);
  const pointDoc = await pointDocRef.get();
  const pointData = pointDoc.data();
  logger.log(pointData);

  if (!pointData) {
    await pointDocRef.set({ mint: amount });
    res.send("purchase success");
    return;
  }

  const mintAmount = parseInt(pointData["mint"]);
  logger.log(mintAmount);

  if (!mintAmount) {
    await pointDocRef.set({ mint: amount }, { merge: true });
    res.send("purchase success");
    return;
  }

  await pointDocRef.set({ mint: mintAmount + amount }, { merge: true });
  res.send("purchase success");
});

export default points;

