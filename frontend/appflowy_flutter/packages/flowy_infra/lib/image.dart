import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgWidget(String name, {Size? size, Color? color}) {
  if (size != null) {
    return SizedBox.fromSize(
      size: size,
      child: SvgPicture.asset(
        'assets/images/$name.svg',
        colorFilter: ColorFilter.mode(color ?? Colors.black, BlendMode.color),
      ),
    );
  } else {
    return SvgPicture.asset(
      'assets/images/$name.svg',
      colorFilter: ColorFilter.mode(color ?? Colors.black, BlendMode.color),
    );
  }
}
