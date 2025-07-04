import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_library/src/features/main/presentation/pages/supportive/bookview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../config/theme.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final history = BlocProvider.of<AuthBloc>(context).history;
    /*final book_data = BlocProvider.of<AuthBloc>(context).book_data;
    final rating = BlocProvider.of<AuthBloc>(context).final_rate;
    //final bloc  BlocProvider.of<AuthBloc>(context);
    List k = [];


    for(int i=0;i<book_data.length;i++) {
      for(int j=0;j<history.length;j++)
      {
        if (history[j]['id'] == book_data[i]['id']) {
          k.add(i);
        }
      }
    }*/
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.orange),
          backgroundColor: Colors.grey[50],
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: (history.isEmpty)
              ? Center(
                  child: Column(
                  children: [
                    Lottie.asset('images/search.json',
                        height: 250.sp, reverse: true),
                    Text("Nothing in History",
                        style: size(20.sp, Colors.orange, true)),
                  ],
                ))
              : ListView.separated(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return InkWell(onTap: () {
                      Get.to(() => BookView(history[index]));
                    },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(
                                        history[index]['image'].toString().replaceAll('localhost', ip))),
                                color: Colors.orange.shade100,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            width: 70.w,
                            height: 90.h,
                          ),

                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 250.w,
                                child: Text(
                                  history[index]['name'],
                                  style: size(18.sp, Colors.black, true),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Text("By : ",
                                      style: size(
                                        15.sp,
                                        Colors.black.withOpacity(0.4),
                                        false,
                                      )),
                                  Text(
                                    history[index]['author'],
                                    style: size(16.sp, Colors.orange, false),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                "${BlocProvider.of<AuthBloc>(context).currencySymbol} ${history[index]['price'].toString()}",
                                style: size(18.sp, Colors.black, false),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    itemSize: 20,
                                    initialRating: history[index]['star'] ?? 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (double value) {},
                                  ),
                                  SizedBox(width: 30,),
                                  Text("${DateTime.parse(history[index]['time']).day.toString()}/${DateTime.parse(history[index]['time']).month.toString()}/${DateTime.parse(history[index]['time']).year.toString()}",style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
        ));
  }
}
