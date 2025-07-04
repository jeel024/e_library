import 'package:e_library/src/features/main/presentation/pages/supportive/bookview.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/firebase.dart';
import '../../../../../config/theme.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        backgroundColor: Colors.grey[50],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recommended Books",
                style: size(20.sp, Colors.black, true),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 580.h,
                child: ListView.builder(
                  itemCount: bloc.book_data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(alignment: Alignment.topRight, children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => BookView(bloc.book_data[index]));
                              },
                              child: Container(
                                decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: CachedNetworkImageProvider(bloc.book_data[index]['image'].toString()
                                    .replaceAll('localhost', '$ip'))),
                                    color: Colors.orange.shade100,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                width: 90.w,
                                height: 100.h,
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.all(8.sp),
                            //   child: FavoriteButton(
                            //     iconSize: 10,
                            //     isFavorite: bloc.liked[index],
                            //     valueChanged: (isFavorite) {
                            //       if (isFavorite) {
                            //         bloc.liked_book.add(bloc.book_data[index]);
                            //         bloc.liked[index] = true;
                            //         store_data(context);
                            //       } else {
                            //         bloc.liked_book.remove(bloc.book_data[index]);
                            //         bloc.liked[index] = false;
                            //         store_data(context);
                            //       }
                            //     },
                            //   ),
                            // ),
                          ]),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bloc.book_data[index]['name'],
                                style: size(15.sp, Colors.black, true),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                bloc.book_data[index]['author'],
                                style: size(14.sp,
                                    Colors.black.withOpacity(0.5), false),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (bloc.book_data[index]['price']=='0') ? Text("free",style: size(15.sp, Colors.orange,true),): Text(" ${bloc.currencySymbol}",
                                      style: size(13.sp, Colors.black, false)),
                                  (bloc.book_data[index]['price']=='0') ? const SizedBox():Text(" ${bloc.book_data[index]['pricedrop']}",
                                      style: TextStyle(fontSize: 13.sp,decoration: TextDecoration.lineThrough)),
                                  (bloc.book_data[index]['price']=='0') ? const SizedBox():Text(" ${bloc.book_data[index]['price']}",
                                      style: size(13.sp, Colors.black, false)),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    itemSize: 20,
                                    initialRating: bloc.book_data[index]['star'] ?? 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (double value) {},
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              SizedBox(
                                  height: 40,
                                  width: 220,
                                  child: Text(
                                      bloc.book_data[index]['description'],style: size(15.sp, Colors.black, false),
                                    maxLines: 2,
                                  ))
                            ],
                          )
                        ],
                      ),
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
