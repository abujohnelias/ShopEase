

import 'package:flutter/material.dart';

extension SizedBoxExtension on SizedBox {
  static SizedBox height(double height) => SizedBox(height: height);

  static SizedBox width(double width) => SizedBox(width: width);

  static SizedBox square(double size) => SizedBox(width: size, height: size);

  static SizedBox fromDimensions({double? width, double? height}) =>
      SizedBox(width: width, height: height);
}
