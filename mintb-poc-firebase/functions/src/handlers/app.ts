
import * as express from "express";
import { onRequest } from "firebase-functions/v2/https";
import { DEFAULT_REGION } from "../env";
import { logger } from "firebase-functions/v2";

const app = express();
app.get('/hello', (req, res) => {
  logger.log(req);
  // 경매와 관련된 로직 처리
  res.status(200).send('Hello');
});

export const api = onRequest({ region: DEFAULT_REGION }, app);