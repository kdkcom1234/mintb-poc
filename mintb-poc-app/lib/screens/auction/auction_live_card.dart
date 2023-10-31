import 'package:flutter/material.dart';
import 'package:mintb_poc_app/firebase/firestore/auction_collection.dart';

import '../../firebase/firestore/profile_collection.dart';
import '../../utils.dart';

class AuctionLiveCard extends StatelessWidget {
  const AuctionLiveCard(this.auctionData,
      {super.key, this.profileData, this.onPressed});

  final AuctionCollection auctionData;
  final ProfileCollection? profileData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final profileData = this.profileData;

    return Container(
        decoration: BoxDecoration(
          image: profileData == null
              ? null
              : DecorationImage(
                  image: NetworkImage(profileData.images[0]),
                  fit: BoxFit.cover,
                ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 38,
              left: 18,
              child: SizedBox(
                height: 51,
                width: MediaQuery.of(context).size.width - 62,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          profileData == null
                              ? ""
                              : "${profileData.nickname}, ${profileData.age}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 1.0,
                                color: Color.fromRGBO(0, 0, 0, 0.60),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "Influencer, 168cm",
                          style: TextStyle(
                            color: Color(0xFFD5DBDB),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 1.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/check_badge.png",
                              width: 20,
                              height: 20.15,
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Image.asset(
                              "assets/profile_badge.png",
                              width: 20,
                              height: 20.98,
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12.5),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF282831),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFFFB74D)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 2,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        formatDuration(auctionData.duration!
                            .toDate()
                            .difference(DateTime.now())),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFFB74D),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    )))
          ],
        ));
  }
}
