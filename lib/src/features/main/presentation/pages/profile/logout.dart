import 'package:e_library/src/config/contants/variable_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../main.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../bloc/auth/auth_state.dart';
import '../../../../../config/theme.dart';
import '../../../../auth/presentation/pages/clear_data.dart';
import '../../../../auth/presentation/pages/login.dart';

logout(BuildContext context) {
Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Container(
        height: 300.h,
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                height: 50.h,
                width: 60.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange.shade100),
                child: Icon(
                  Icons.exit_to_app,
                  size: 40.r,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "Logout",
                style: size(25.sp, Colors.red, true),
              ),
              SizedBox(height: 5.h),
              Text(
                "Are You sure to Logout ? ",
                style: size(15.sp, Colors.black.withOpacity(0.5), false),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () async {
                  clear(context);
                    cn.page.value = 0;
                  BlocProvider.of<AuthBloc>(context).add(Sign_out());


                },
                child:(BlocBuilder<AuthBloc,AuthState>(builder: (context, state) {
                  return Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 45.h,
                    decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                  );

                },))

              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 45.h,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
