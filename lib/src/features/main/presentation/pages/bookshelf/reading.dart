import 'dart:io';
import 'package:e_library/src/features/main/presentation/pages/supportive/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/logic_bloc/logic_bloc.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/theme.dart';
import '../supportive/openfile.dart';

class Reading extends StatefulWidget {
  const Reading({Key? key}) : super(key: key);

  @override
  State<Reading> createState() => _ReadingState();
}

class _ReadingState extends State<Reading> {
  Mycontroll cn = Get.put(Mycontroll(), permanent: true);
  List read = [];
  List unread_last = [];
  List unread = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bloc = BlocProvider.of<AuthBloc>(context);
    for(int i=0;i<bloc.last.length;i++)
      {
        if(bloc.last[i]['page'] == 0 && bloc.last[i]['scroll'] == 0.0 )
          {
            unread.add(bloc.download_books[i]);
            unread_last.add(bloc.last[i]);
          }
        else
          {
            read.add(bloc.download_books[i]);
          }
      }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "(0${read.length.toString()}) Reading",
            style: size(18.sp, Colors.black, true),
          ),
          SizedBox(
            height: 12.h,
          ),
          (read.isEmpty) ?  Text("Nothing that you are reading",style: size(17.sp, Colors.orange,true),):SizedBox(
            height: 200.w,
            child: ListView.builder(
              itemCount: read.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(onTap: () {


                        File f = File(read[index]['path']);
                        BlocProvider.of<LogicBloc>(context).path = f;
                        cn.current.value = BlocProvider.of<AuthBloc>(context).last[index]['page'];
                        cn.last.value = BlocProvider.of<AuthBloc>(context).last[index]['scroll'];


                        Get.to(() =>  OpenBook(BlocProvider.of<AuthBloc>(context).last[index]['id'],true,''));
                      },
                        child: Container(
                          decoration: BoxDecoration( image: DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(File(read[index]['image']))),
                              color: Colors.orange.shade100,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          width: 90.w,
                          height: 95.h,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(width: 90.w,
                        child: Text(
                          read[index]['name'],
                          style: size(15.sp, Colors.black, false),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      InkWell(onTap: () {
                        Get.to(() => Rating(read[index]));
                      },child: Text("Rate a book",style: size(17.sp, Colors.orange,false),))

                    ],
                  ),
                ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            "(0${unread.length.toString()}) Unread",
            style: size(18.sp, Colors.black, true),
          ),
          SizedBox(
            height: 12.h,
          ),
          (unread.isEmpty) ?  Text("Nothing to show",style: size(18.sp, Colors.orange, true),):SizedBox(
            height: 200.h,
            child: ListView.builder(
              itemCount: unread.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: InkWell(onTap: () {
                    File f = File(unread[index]['path']);
                    BlocProvider.of<LogicBloc>(context).path = f;
                    cn.current.value = unread_last[index]['page'];
                    cn.last.value = unread_last[index]['scroll'];

                    Get.to(() =>  OpenBook(unread_last[index]['id'].toString(),true,''));
                  },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(alignment: Alignment.topRight, children: [
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(File(unread[index]['image']))),
                                  color: Colors.orange.shade100,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              width: 90.w,
                              height: 100.h,
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(width: 90.w,
                          child: Text(
                            unread[index]['name'],
                            style: size(14.sp, Colors.black, false),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
