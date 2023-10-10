import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/album_selector.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaSelector extends StatefulWidget {
  const MediaSelector({super.key, this.maxSelectSize = 6});
  final int maxSelectSize;

  @override
  State<StatefulWidget> createState() {
    return _MediaSelectorState();
  }
}

class _MediaSelectorState extends State<MediaSelector> {
  final List<File?> images = [];
  final List<int> selectedImageIndexes = [];
  var loading = false;

  AssetPathEntity? currentPath;
  var currentBlock = 0;
  var blockSize = 21;

  final ScrollController gridController = ScrollController();

  Future<void> fetchImages({final bool more = false}) async {
    if (!more) {
      currentBlock = 0;
      images.clear();
      selectedImageIndexes.clear();
    }

    if (currentPath != null) {
      final List<AssetEntity> entities = (await currentPath!
              .getAssetListPaged(page: currentBlock, size: blockSize))
          .where((e) => e.type == AssetType.image)
          .toList();

      // log(entities.toString());

      for (final entity in entities) {
        images.add(await entity.file);
      }
      // log(images.toString());

      setState(() {
        loading = false;
        if (!more) {
          gridController.jumpTo(0);
        }
      });
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
        log(paths.toString());

        final path = paths.firstWhere((e) => e.id == "isAll");
        currentPath = path;
        fetchImages();

        gridController.addListener(() async {
          if (gridController.hasClients) {
            if (gridController.position.maxScrollExtent ==
                gridController.offset) {
              currentBlock += 1;
              fetchImages(more: true);
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
                                  /* -- 저장하기 버튼 */
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final List<File?> sortedByIndexImages =
                                          [];
                                      for (final selectedIndex
                                          in selectedImageIndexes) {
                                        sortedByIndexImages.add(
                                            images.firstWhere((element) =>
                                                images.indexOf(element) ==
                                                selectedIndex));
                                      }

                                      Navigator.of(context)
                                          .pop(sortedByIndexImages);
                                    },
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
                /* -- selected album, length */
                Container(
                  color: const Color(0xFF343434),
                  padding: const EdgeInsets.only(
                      left: 8, top: 8, bottom: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /* -- 앨범 선택 버튼 --*/
                      OutlinedButton(
                          onPressed: () async {
                            final result = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => const AlbumSelector(),
                              fullscreenDialog: true,
                            )) as AssetPathEntity?;

                            if (result != null) {
                              currentPath = result;
                              fetchImages();
                            }
                          },
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
                        '${selectedImageIndexes.length} / ${widget.maxSelectSize} 선택됨',
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
                /* -- 이미지 프리뷰 */
                selectedImageIndexes.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(1),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Image.file(
                          images[selectedImageIndexes.last]!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox.shrink(),
                /* -- image list */
                Expanded(
                    child: Container(
                        color: const Color(0xFF343434),
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
                                      if (selectedImageIndexes
                                          .contains(index)) {
                                        selectedImageIndexes.remove(index);
                                      } else {
                                        if (selectedImageIndexes.length ==
                                            widget.maxSelectSize) {
                                          return;
                                        }
                                        selectedImageIndexes.add(index);
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
                                      /* -- 선택 외각선 */
                                      Positioned(
                                          child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: selectedImageIndexes
                                                .contains(index)
                                            ? const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF25ECD7)),
                                                ),
                                              )
                                            : null,
                                      )),
                                      /* -- 체크박스 */
                                      Positioned(
                                        top: 8,
                                        right: 6,
                                        child: Image.asset(
                                          selectedImageIndexes.contains(index)
                                              ? "assets/check_active_transparent.png"
                                              : "assets/check_inactive.png",
                                          width: 20,
                                        ),
                                      )
                                    ],
                                  ));
                            })))
              ],
            ))));
  }
}
