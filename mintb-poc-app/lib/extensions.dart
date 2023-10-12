import 'dart:math';

extension TruncateDoubles on double {
  double truncateToDecimalPlaces(int fractionalDigits) =>
      (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
}

extension FormatString on String {
  String formatNumberWithCommas() {
    // 소숫점의 위치를 찾습니다.
    int decimalIndex = indexOf('.');

    // 소숫점이 없으면 전체 문자열을 처리, 있으면 소숫점 앞 부분만 처리
    String mainPart = decimalIndex == -1 ? this : substring(0, decimalIndex);
    String decimalPart = decimalIndex == -1 ? '' : substring(decimalIndex);

    // 3자리마다 콤마를 추가
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formattedMainPart =
        mainPart.replaceAllMapped(reg, (Match match) => '${match[1]},');

    // 결과 반환
    return '$formattedMainPart$decimalPart';
  }

  String shortenFromAddress() {
    return "${substring(0, 5)}...${substring(length - 5, length)}";
  }

  String removeCommas() {
    return replaceAll(",", "");
  }

  double toDouble() {
    return double.parse(removeCommas());
  }
}
