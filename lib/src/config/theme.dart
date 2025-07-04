import 'package:flutter/material.dart';

TextStyle size(double size, Color c, [bool? t]) {
  return TextStyle(
      fontSize: size, fontWeight: (t!) ? FontWeight.bold : null, color: c);
}

