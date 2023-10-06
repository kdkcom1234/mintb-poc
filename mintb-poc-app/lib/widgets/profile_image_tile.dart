import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImageTile extends StatelessWidget {
  const ProfileImageTile(
      {super.key, this.isPrimary = false, this.file, this.onTap});
  final bool isPrimary;
  final File? file;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Stack(
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
                  ),
                ],
              ),
            ),
            file != null
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: Image.file(
                      file!,
                      width: isPrimary ? 214 : 100,
                      height: isPrimary ? 214 : 100,
                      fit: BoxFit.cover,
                    ))
                : const SizedBox.shrink(),
            isPrimary
                ? Positioned(
                    left: 13,
                    top: 10,
                    child: Container(
                        width: 48,
                        height: 24,
                        decoration: ShapeDecoration(
                          color: Colors.transparent,
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
        ));
  }
}
