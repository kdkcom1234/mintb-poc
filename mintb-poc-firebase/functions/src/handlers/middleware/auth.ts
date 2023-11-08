import { Request, Response, NextFunction } from 'express';
import admin from '../../admin';
import { logger } from 'firebase-functions/v2';

// req.user에 대한 타입을 확장하기 위해, Request 타입을 확장합니다.
export interface RequestWithUser extends Request {
  user?: admin.auth.DecodedIdToken; // or any other type that represents your user object
}

const authMiddleware = async (req: RequestWithUser, res: Response, next: NextFunction) => {
  if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
    logger.log("Unauthorized");
    res.status(403).send('Unauthorized');
    return;
  }

  const idToken = req.headers.authorization.split('Bearer ')[1];
  try {
    const decodedIdToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedIdToken;
    next();
  } catch (e) {
    logger.log("Unauthorized");
    res.status(403).send('Unauthorized');
  }
};

export default authMiddleware;


