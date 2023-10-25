import 'package:flutter/material.dart';

class CustomSliderThumbShape extends RoundSliderThumbShape {
  final double thumbRadius;

  CustomSliderThumbShape({this.thumbRadius = 10.0});

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    // TODO: implement paint
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = const Color(0xFF3EDFCF)
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromCenter(
      center: center,
      width: 2 * thumbRadius,
      height: 2 * thumbRadius,
    );

    final RRect rRect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(4),
    );

    canvas.drawRRect(rRect, paint);
  }
}

class CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
