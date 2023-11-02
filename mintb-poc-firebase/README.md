-- deploy rules

```bash
firebase deploy --only firestore:rules
firebase deploy --only storage
```

-- deploy functions

```bash
firebase deploy --only functions
```

-- logging functions

```bash
firebase functions:log --only auctionBidRequestsCreated
```

-- run emulator
```bash
firebase emulators:start
```
