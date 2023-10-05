import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaSelector extends StatefulWidget {
  const MediaSelector({super.key, this.maxSelectSize = 5});
  final int maxSelectSize;

  @override
  State<StatefulWidget> createState() {
    return _MediaSelectorState();
  }
}

class _MediaSelectorState extends State<MediaSelector> {
  final List<File?> images = [];
  final selectedImages = [];
  var loading = false;

  AssetPathEntity? currentPath;
  var currentBlock = 0;
  var blockSize = 21;

  final ScrollController gridController = ScrollController();

  Future<void> fetchImages() async {
    final currentPath = this.currentPath;

    if (currentPath != null) {
      final List<AssetEntity> entities = (await currentPath.getAssetListPaged(
              page: currentBlock, size: blockSize))
          .where((e) => e.type == AssetType.image)
          .toList();

      // log(entities.toString());

      for (final entity in entities) {
        images.add(await entity.file);
      }

      // log(images.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    (() async {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        // Granted.
        final List<AssetPathEntity> paths =
            await PhotoManager.getAssetPathList();
        // log(paths.toString());

        final path = paths.firstWhere((e) => e.id == "isAll");
        currentPath = path;
        // log(path.toString());

        images.clear();
        await fetchImages();

        setState(() {
          loading = false;
        });

        gridController.addListener(() async {
          if (gridController.hasClients) {
            if (gridController.position.maxScrollExtent ==
                gridController.offset) {
              await fetchImages();
              setState(() {
                currentBlock += 1;
              });
            }
          }
        });
      } else {
        // Limited(iOS) or Rejected, use `==` for more precise judgements.
        // You can call `PhotoManager.openSetting()` to open settings for further steps.
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
            child: SafeArea(
                child: Column(
              children: [
                /* -- top menu bar */
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  color: const Color(0xFF1C1C26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 68,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Image(
                                  image: AssetImage("assets/close_button.png"),
                                  width: 38,
                                  height: 38,
                                ),
                              ),
                            ],
                          )),
                      const Text(
                        '사진 선택하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      ),
                      SizedBox(
                          width: 68,
                          child: Stack(
                            children: [
                              Positioned(
                                  right: 8,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(60, 32),
                                        backgroundColor:
                                            const Color(0xFF25ECD7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    child: const Text(
                                      '저장하기',
                                      style: TextStyle(
                                        color: Color(0xFF343434),
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w800,
                                        height: 0,
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                    ],
                  ),
                ),
                /* -- folder, length */
                Container(
                  color: const Color(0xFF343434),
                  padding: const EdgeInsets.only(
                      left: 8, top: 8, bottom: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              minimumSize: const Size(60, 32),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                  width: 1, color: Color(0xFF3DDFCE))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentPath != null ? currentPath!.name : "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF3EDFCF),
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w800,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Image(
                                image:
                                    AssetImage("assets/down_caret_primary.png"),
                                width: 10,
                              )
                            ],
                          )),
                      Text(
                        '${selectedImages.length} / ${widget.maxSelectSize} 선택됨',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF3DDFCE),
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
                /* -- image list */
                Expanded(
                    child: GridView.builder(
                        controller: gridController,
                        itemCount: images.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 1, //수평 Padding
                          crossAxisSpacing: 1, //수직 Padding
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedImages.contains(index)) {
                                    selectedImages.remove(index);
                                  } else {
                                    if (selectedImages.length ==
                                        widget.maxSelectSize) {
                                      return;
                                    }
                                    selectedImages.add(index);
                                  }
                                });
                              },
                              child: Stack(
                                children: [
                                  Image.file(
                                    images[index]!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                      child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width:
                                                selectedImages.contains(index)
                                                    ? 2
                                                    : 0,
                                            color: const Color(0xFF25ECD7)),
                                      ),
                                    ),
                                  )),
                                  Positioned(
                                    top: 8,
                                    right: 6,
                                    child: Image.asset(
                                      selectedImages.contains(index)
                                          ? "assets/check_active_transparent.png"
                                          : "assets/check_inactive.png",
                                      width: 20,
                                    ),
                                  )
                                ],
                              ));
                        }))
              ],
            ))));
  }
}
