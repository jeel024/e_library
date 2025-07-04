import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../config/contants/button.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/theme.dart';

class Personal_Info extends StatefulWidget {
  const Personal_Info({Key? key}) : super(key: key);

  @override
  State<Personal_Info> createState() => _Personal_InfoState();
}

class _Personal_InfoState extends State<Personal_Info> {
  @override
  TextEditingController name = TextEditingController();
  Mycontroll controller = Get.put(Mycontroll());
  DateTime? date;
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = BlocProvider.of<AuthBloc>(context).getProfile!.fullName.toString();
    controller.cntry.value = BlocProvider.of<AuthBloc>(context).getProfile!.country.toString();
    controller.dob.value = BlocProvider.of<AuthBloc>(context).getProfile!.birthDate.toString();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        backgroundColor: Colors.grey[50],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full Name",
                style: size(17.sp, Colors.black, false),
              ),
              SizedBox(
                height: 5.h,
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.orange.withOpacity(0.2),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Colors.orange.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Colors.orange.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Name here"),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Add Country",
                style: size(17.sp, Colors.black, false),
              ),
              SizedBox(
                height: 5.h,
              ),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Country",
                                style: size(18.sp, Colors.black, true),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                height: 230.h,
                                child: ListView.builder(
                                    itemCount: country.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () {
                                          controller.cntry.value  = country[index];
                                          // controller.update();
                                          /* BlocProvider.of<LogicBloc>(
                                                context)
                                                .add(Country(country[index]));*/
                                          Get.back();
                                        },
                                        trailing: Radio(
                                          activeColor: Colors.orange,
                                          value: country[index],
                                          groupValue:
                                          controller.cntry.value,
                                          onChanged: (value) {
                                            controller.cntry.value  = country[index];
                                            // controller.update();
                                          },
                                        ),
                                        title: Text(country[index]),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.orange.withOpacity(0.5), width: 2),
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () =>  Text(
                            (controller.cntry
                                .isEmpty)
                                ? "Select Country"
                                : controller.cntry.value,
                            style: size(
                                16.sp, Colors.black.withOpacity(0.5), false),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Date Of Birth",
                style: size(17.sp, Colors.black, false),
              ),
              SizedBox(
                height: 5.h,
              ),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Date Of Birth",
                                style: size(18.sp, Colors.black, true),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                height: 200,
                                child: CupertinoDatePicker(
                                  initialDateTime: date,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (DateTime newDate) {
                                    setState(() => date = newDate);
                                  },
                                ),
                              ),
                              SizedBox(height: 10.h),
                              InkWell(
                                onTap: () {
                                  controller.dob.value =  date.toString();
                                  // controller.update();
                                  print(controller.dob.value);
                                  Get.back();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.sp),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 55,
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.orange.withOpacity(0.5), width: 2),
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () {
                            DateTime date = DateTime.parse(controller.dob.value);
                            return Text(

                            (controller.dob.isEmpty)
                                ? "Select date of birth"
                                : "${date.day}-${date.month}-${date.year}",
                            style: size(
                                16.sp, Colors.black.withOpacity(0.5), false),
                          );
                          },
                        ),
                        const Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 250.h,
              ),
              InkWell(
                onTap: () async {
                  // BlocProvider.of<LogicBloc>(context).add(UserName(name.text));
                  // BlocProvider.of<LogicBloc>(context).name = name.text;
                  // store_data(context);
                  BlocProvider.of<AuthBloc>(context).add(UpdateProfile(name.text,controller.cntry.value,DateTime.parse(controller.dob.value)));
                  BlocProvider.of<AuthBloc>(context).add(Bookdata());
                  Get.offAll(HomeScreen());
                },
                child: button("Save"),
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () async{
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Get.back();
      return true;
    },);
  }
}
