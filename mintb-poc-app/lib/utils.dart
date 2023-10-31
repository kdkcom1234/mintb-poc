String formatDuration(Duration d) {
  if (d.isNegative) {
    return "00:00:00";
  }
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
}
