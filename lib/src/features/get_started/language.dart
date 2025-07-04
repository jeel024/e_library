

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../bloc/logic_bloc/logic_bloc.dart';
import '../../bloc/logic_bloc/logic_event.dart';
import '../../bloc/logic_bloc/logic_state.dart';
import '../../config/contants/button.dart';
import '../../config/contants/snackbar.dart';
import '../../config/theme.dart';

import 'welcome.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Choose",
              style: TextStyle(
                  fontSize: 25.sp,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Your Language",
              style: TextStyle(
                fontSize: 25.sp,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(onTap: () {
              BlocProvider.of<LogicBloc>(context).add(GetLanguage("Arbic"));
            }, child: BlocBuilder<LogicBloc, LogicState>(
              builder: (context, state) {
                 if (state is LogicLoading) {
                  return const CircularProgressIndicator();
                }
                return Container(
                    width: double.infinity.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        color: (BlocProvider.of<LogicBloc>(context).language ==
                                "Arbic")
                            ? Colors.orange
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                 Text("أهلاً!",
                                    style: size(18.sp, Colors.black, true))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Arbic",
                                    style: size(18.sp, Colors.black, true)),
                                Text("انا سام",
                                    style: size(18.sp, Colors.black, true))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            )),
            SizedBox(
              height: 20.h,
            ),
            InkWell(onTap: () {
              BlocProvider.of<LogicBloc>(context).add(GetLanguage("English"));
            }, child: BlocBuilder<LogicBloc, LogicState>(
              builder: (context, state) {
               if (state is LogicLoading) {
                  return const CircularProgressIndicator();
                }
                return Container(
                    width: double.infinity.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        color: (BlocProvider.of<LogicBloc>(context).language ==
                                "English")
                            ? Colors.orange
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Hiii!",
                                  style: size(18.sp, Colors.black, true))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "English",
                                style: size(18.sp, Colors.black, true),
                              ),
                              Text("I'm Sam",
                                  style: size(18.sp, Colors.black, true))
                            ],
                          ),
                          //SizedBox(height: h*0.001,)
                        ],
                      ),
                    ));
              },
            )),
            SizedBox(
              height: 270.h,
            ),
            InkWell(
                onTap: () {
                  if (BlocProvider.of<LogicBloc>(context).language!='') {
                    Get.off(() => const Welcome());
                  } else {
                    errorSnackbar("Please select language");
                  }
                },
                child: button("Get Started"))
          ],
        ),
      )),
    );
  }
}
