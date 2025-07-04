import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../bloc/auth/auth_bloc.dart';
import '../../../../bloc/auth/auth_event.dart';
import '../../../../config/contants/button.dart';
import '../../../../config/contants/snackbar.dart';
import '../../../../config/contants/variable_const.dart';
import '../../../../config/theme.dart';
import '../../../../model/getgender_model.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}
class _CategoryState extends State<Category> {
  Mycontroll cn = Get.put(Mycontroll(),permanent: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Mycontroll>(builder: (controller) {
   //   controller.ctgy.value = genderModel!.category!;
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Text("You can choose Multiple",
                    style: size(17.sp, Colors.black.withOpacity(0.5), false)),
                SizedBox(
                  height: 15.h,
                ),
                Center(
                    child: Text(
                        textAlign: TextAlign.center,
                        "Please Choose Your\nBook Categories",
                        style: size(23.sp, Colors.black, true))),
                SizedBox(
                  height: 10.h,
                ),
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: AssetImage(
                      'images/${cn.gender.value}.png'),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 380.h,
                  width: double.infinity,
                  child: GridView.builder(physics: const NeverScrollableScrollPhysics(),
                    itemCount: ctgr.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 5,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {

                            if(controller.ctgy.contains(ctgr[index]))
                            {
                              controller.ctgy.value.remove(ctgr[index]);
                            }
                            else
                            {
                              controller.ctgy.add(ctgr[index]);
                            }
                            controller.update();
                            print(controller.ctgy);
                            print(controller.ctgy
                                .contains(ctgr[index]));
                            //BlocProvider.of<LogicBloc>(context).add(GetCategory(ctgr[index]));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                color: (controller.ctgy
                                    .contains(ctgr[index]))
                                    ? Colors.orange
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              ctgr[index],
                              style: size(15.sp, Colors.black, false),
                            ),
                          ));
                    },
                  ),
                ),
                InkWell(
                    onTap: () {
                      if (controller.ctgy.isNotEmpty) {
                        BlocProvider.of<AuthBloc>(context).add(StoreGender());
                        //store_data(context);
                        //Get.off(() => const HomeScreen());
                      } else {
                        errorSnackbar("Please select Category");
                      }
                    },
                    child: button("Next")),
              ],
            ),
          ),
        ),
      );
    },
    );
  }
}
