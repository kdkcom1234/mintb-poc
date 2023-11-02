import 'package:intl/intl.dart';

String formatDuration(Duration d) {
  if (d.isNegative) {
    return "00:00:00";
  }
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
}

String formatDateTime(DateTime dateTime) {
  // `intl`을 사용하여 원하는 형식으로 날짜와 시간을 포맷팅합니다.
  return DateFormat("yy.MM.dd hh:mm a").format(dateTime);
}
