-- deploy rules

```bash
firebase deploy --only firestore:rules
firebase deploy --only storage
```

-- deploy functions

```bash
firebase deploy --only functions
```

-- logging functions(remote)

```bash
firebase functions:log --only auctionBidRequestsCreated
```


-- run emulator with watch mode
```bash
./start.sh
```

