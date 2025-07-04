import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

button(String str) {
  return Container(
    alignment: Alignment.center,
    width: double.infinity.w,
    height: 40.h,
    decoration: BoxDecoration(
        color: Colors.orange, borderRadius: BorderRadius.circular(5)),
    child: Text(
      str,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.sp),
    ),
  );
}