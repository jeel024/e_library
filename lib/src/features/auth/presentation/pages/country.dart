import 'package:e_library/src/bloc/auth/auth_bloc.dart';
import 'package:e_library/src/bloc/auth/auth_event.dart';
import 'package:e_library/src/config/contants/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../config/contants/variable_const.dart';
import '../../../../config/theme.dart';

class Country extends StatefulWidget {
  const Country({super.key});

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  Mycontroll controller = Get.put(Mycontroll());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Select Your Country",
                style: size(20.sp, Colors.black, true),
              ),
              SizedBox(
                height: 50.h,
              ),
              Container(
                height: 230.h,
                child: ListView.builder(physics: BouncingScrollPhysics(),
                    itemCount: country.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(color: (country[index] == controller.cntry.value) ? Colors.orange : Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: ListTile(

                              onTap: () {
                                controller.cntry.value = country[index];
                              },
                              title: Center(child: Text(country[index])),
                            ),
                          ),
                        )
                      );
                    }),
              ),
              SizedBox(height: 50.h,),
              Obx(
                () =>  (controller.cntry.value.isEmpty) ? SizedBox() : InkWell(onTap: () {

                  BlocProvider.of<AuthBloc>(context).add(Cntry());

                },child:  button("Next"),),
              ) ,
            ],
          ),
        ),

      ),
    );
  }
}
