import 'package:flutter/cupertino.dart';

class ProfileImageTile extends StatelessWidget {
  const ProfileImageTile({super.key, this.isPrimary = false});
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: isPrimary ? 214 : 100,
          height: isPrimary ? 214 : 100,
          decoration: ShapeDecoration(
            color: const Color(0xFF282831),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage("assets/add_icon.png"),
                width: isPrimary ? 24 : 16,
                height: isPrimary ? 24 : 16,
              )
            ],
          ),
        ),
        isPrimary
            ? Positioned(
                left: 13,
                top: 10,
                child: Container(
                    width: 48,
                    height: 24,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF343434),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF25ECD7)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '메인',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF25ECD7),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ],
                    )))
            : const SizedBox.shrink(),
      ],
    );
  }
}
