import 'package:e_library/src/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../config/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../supportive/bookview.dart';
import '../../../../../config/contants/variable_const.dart';
class Save extends StatelessWidget {
  const Save({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.orange),
          backgroundColor: Colors.grey[50],
          elevation: 0,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    return Padding(
          padding: const EdgeInsets.all(12.0),
          child: (bloc.liked_book.isEmpty) ?  Center(
            child: Column(
              children: [
                Lottie.asset('images/search.json',
                    height: 250.sp, reverse: true),
                Text("Nothing that you liked",
                    style: size(20.sp, Colors.orange, true)),
              ],
            ),
          ):ListView.separated(
            itemCount: bloc.liked_book.length,
            itemBuilder: (context, index) {
              print(index);
              print(bloc.liked_book[index]);
              print(bloc.liked_book.length);
              return InkWell(onTap: () {
                Get.to(() => BookView(bloc.liked_book[index]));
              },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: CachedNetworkImageProvider(bloc.liked_book[index]['image'].toString().replaceAll('localhost', '$ip'))),
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
                            bloc.liked_book[index]['name'],
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
                              bloc.liked_book[index]['author'],
                              style: size(16.sp, Colors.orange, false),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "${bloc.currencySymbol} ${bloc.liked_book[index]['price']}",
                          style: size(18.sp, Colors.black, false),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        RatingBar.builder(
                          ignoreGestures: true,
                          itemSize: 20,
                          initialRating: 4,
                          // initialRating: bloc.liked_book[index]['star'].toDouble() ?? 0,
                          minRating: 0.5,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          //itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double value) {},
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
        );
  },
));
  }
}
