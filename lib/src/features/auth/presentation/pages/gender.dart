import 'package:e_library/src/features/auth/presentation/pages/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/contants/button.dart';
import '../../../../config/contants/snackbar.dart';
import '../../../../config/contants/variable_const.dart';
import '../../../../config/theme.dart';
import 'category.dart';

class Gender extends StatefulWidget {
  const Gender({Key? key}) : super(key: key);

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  bool temp = false;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: GetX<Mycontroll>(builder:  (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  "Let's get to know you",
                  style: size(15.sp, Colors.black.withOpacity(0.5), false),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Select Gender",
                  style: size(20.sp, Colors.black, true),
                ),
                SizedBox(
                  height: 15.h,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side:
                        (controller.gender ==
                            "Male")
                            ? const BorderSide(
                            width: 5.0, color: Colors.orange)
                            : null,
                        shape: const CircleBorder()),
                    onPressed: () {
                      cn.gender.value = "Male";
                      // BlocProvider.of<LogicBloc>(context)
                      //     .add(GetGender("Male"));
                    },
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage:
                      const AssetImage('images/Male.png'),
                    )),
                Text("Male", style: size(18.sp, Colors.black, false)),
                SizedBox(
                  height: 10.h,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: (cn.gender.value ==
                            "Female")
                            ? const BorderSide(
                            width: 5.0, color: Colors.orange)
                            : null,
                        shape: const CircleBorder()),
                    onPressed: () {

                      cn.gender.value = "Female";
                    },
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage:
                      const AssetImage('images/Female.png'),
                    )),
                Text("Female", style: size(18.sp, Colors.black, false)),
                SizedBox(
                  height: 10.h,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: (cn.gender ==
                            "others")
                            ? const BorderSide(
                            width: 5.0, color: Colors.orange)
                            : null,
                        shape: const CircleBorder()),
                    onPressed: () {
                      cn.gender.value = "others";

                    },
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage:
                      const AssetImage('images/others.png'),
                    )),
                SizedBox(
                  height: 70.h,
                ),
                InkWell(
                    onTap: () {
                      if (cn.gender=='' ) {
                        errorSnackbar("Please select Gender");
                      } else {

                        Get.off(() => const Country());
                      }
                    },
                    child: button("Next")),
              ],
            );
          },
          ),
          ),
        ),
    );
  }
}
