 import 'package:dotted_border/dotted_border.dart';
import 'package:e_library/src/features/main/presentation/pages/bag/add_to_bag.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../bloc/logic_bloc/logic_bloc.dart';
import '../../../../../bloc/logic_bloc/logic_event.dart';
import '../../../../../bloc/logic_bloc/logic_state.dart';
import '../../../../../config/contants/textfield.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/theme.dart';

class Coupan extends StatelessWidget {
  const Coupan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController coupan = TextEditingController();
    return Scaffold(
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<LogicBloc, LogicState>(
                builder: (context, state) {
                  return Text(
                    "Maximum Savings : ${BlocProvider.of<LogicBloc>(context).discount}",
                    style: size(17.sp, Colors.black, true),
                  );
                },
              ),
              InkWell(
                  onTap: () {
                    Get.off(const AddToBag());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange),
                    child: Text(
                      "Apply",
                      style: size(17.sp, Colors.white, true),
                    ),
                  ))
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.orange),
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: (130 * coupon.length.toDouble()),
                child: ListView.separated(
                  itemCount: coupon.length,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<LogicBloc, LogicState>(
                          builder: (context, state) {
                            return Radio(
                              toggleable: true,
                              activeColor: Colors.orange,
                              value: coupon[index]['name'],
                              groupValue:
                                  BlocProvider.of<LogicBloc>(context).cpradio,
                              onChanged: (value) {
                                BlocProvider.of<LogicBloc>(context).add(
                                    CoupanRadio(value.toString(),
                                        coupon[index]['save']));
                              },
                            );
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DottedBorder(
                                color: Colors.orange,
                                strokeWidth: 3,
                                padding: EdgeInsets.zero,
                                dashPattern: const [
                                  5,
                                  5,
                                ],
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.orange.shade100),
                                  child: Text(
                                    coupon[index]['name'],
                                    style: size(15.sp, Colors.orange, false),
                                  ),
                                )),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Save ${coupon[index]['save']}",
                              style: size(17.sp, Colors.black, true),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "${coupon[index]['minimum']}",
                              style: size(16.sp, Colors.black, true),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "Expires on ${coupon[index]['exp']}",
                              style: size(16.sp, Colors.black, false),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 5.h,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
