import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/contants/button.dart';
import '../../../../config/contants/textfield.dart';
import '../../../../config/contants/variable_const.dart';
import '../../../../config/theme.dart';
 sendPasswordResetEmail(String email) async {
   http.Response response = await http
       .post(Uri.parse("http://$ip:4000/api/verifyUser"), body: {
     'email' : email
   });
print(response.body);
   if(response.statusCode == 200 || response.statusCode == 201)
     {
       Get.defaultDialog(
         middleText:
         "We have sent Password reset link to your mail.. It may be in spam",
         confirmTextColor: Colors.orange,
         cancel: TextButton(
             onPressed: () async {
               await launch("https://mail.google.com/");
             },
             child: const Text(
               "Open Gmail",
               style: TextStyle(fontSize: 17, color: Colors.orange),
             )),
         title: " Reset Password!!",
       );
     }
}

get_email(BuildContext context, String email) {
  TextEditingController resetEmail = TextEditingController();

  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Container(
          height: MediaQuery.of(context).size.height -  35.h,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton(
                      style:
                          OutlinedButton.styleFrom(shape: const CircleBorder()),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                      )),
                  Image.asset('images/password.jpg'),
                  Text(
                    "You can set new password from link provided in email",
                    style: size(15.sp, Colors.black, false),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Text(
                    "Email Address",
                    style: size(20.sp, Colors.black, false),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  email_textfield(resetEmail, "Enter email here"),
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                      onTap: () {
                        sendPasswordResetEmail(resetEmail.text);
                      },
                      child: button("Reset Password"))
                ],
              ),
            ),
          ));
    },
  );
}
