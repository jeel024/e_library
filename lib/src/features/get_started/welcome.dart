import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/contants/button.dart';
import '../../config/theme.dart';
import '../auth/presentation/pages/login.dart';



class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/library.jpg',
            width: double.infinity,
            height: 380.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "Read Anywhere, Anytime",
            style: size(25.sp, Colors.orange, true),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              textAlign: TextAlign.center,
              "All in your pocket, access anytime, anywhere, any device",
              style: size(17.sp, Colors.black, false),
            ),
          ),
          SizedBox(
            height: 100.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: InkWell(
                onTap: () {
                  Get.off(() => const Login());
                },
                child: button("Get Started")),
          )
        ],
      ),
    );
  }
}
