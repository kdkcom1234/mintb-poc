import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumSelector extends StatefulWidget {
  const AlbumSelector({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlbumSelectorState();
  }
}

class _AlbumSelectorState extends State<AlbumSelector> {
  List<AssetPathEntity> pathList = [];
  List<int> pathAssetCount = [];
  var loading = false;

  @override
  void initState() {
    super.initState();

    (() async {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        pathList = await PhotoManager.getAssetPathList();
        for (final path in pathList) {
          pathAssetCount.add((await path.assetCountAsync));
        }
        // Granted.
        setState(() {
          loading = false;
        });

        // log(paths.toString());
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
                child: Column(children: [
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
                      '앨범 선택하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFE5E5E5),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w800,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 68,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                color: const Color(0xFF343434),
                child: ListView.builder(
                    itemCount: pathList.length,
                    itemBuilder: (context, idx) {
                      return Container(
                          width: double.infinity,
                          height: 80,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF292931),
                            border: Border(
                              top: idx == 0
                                  ? const BorderSide(width: 1)
                                  : const BorderSide(width: 0), // 상단 테두리
                              left: const BorderSide(width: 1), // 좌측 테두리
                              right: const BorderSide(width: 1), // 우측 테두리
                              bottom: const BorderSide(width: 1), // 하단 테두리를 제거
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(pathList[idx]);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      pathList[idx].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFFE5E5E5),
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      pathAssetCount[idx].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF3DDFCE),
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    )
                                  ],
                                ),
                                const Image(
                                  image: AssetImage("assets/next_icon.png"),
                                  width: 10,
                                )
                              ],
                            ),
                          ));
                    }),
              ))
            ]))));
  }
}
