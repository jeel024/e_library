import 'dart:convert';
import '../../../../../config/contants/variable_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../config/theme.dart';
import '../supportive/bookview.dart';
import 'package:http/http.dart' as http;

cat(BuildContext context,String cat)
{
  final bloc = BlocProvider.of<AuthBloc>(context);
List k = [];
  List book_data = [];
  for(int i=0;i<bloc.book_data.length;i++) {
    // var temp = bloc.book_data[i]['category'];
    // var cate = json.decode(bloc.book_data[i]['category']).cast<String>().toList();
    //bloc.book_data[i]['category'] = cate;

    for(int j=0;j<bloc.book_data[i]['category'].length;j++)
      {
        if (cat.contains(bloc.book_data[i]['category'][j])) {
          book_data.add(bloc.book_data[i]);
          if(!bloc.topic.contains(bloc.book_data[i]))
            {
              bloc.topic.add(bloc.book_data[i]);
            }
          k.add(i);
        }
      }
    //cate = temp;
  }

  return Container(
    child: ListView.builder(
      itemCount: book_data.length,
      itemBuilder: (context, index) {

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(onTap: () {
            Get.to(() => BookView(book_data[index]));
          },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: CachedNetworkImageProvider(book_data[index]['image'].toString().replaceAll('localhost', '$ip')
        )),
                      color: Colors.orange.shade100,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  width: 100.w,
                  height: 110.h,
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(width: 220.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book_data[index]['name'],
                        style: size(15.sp, Colors.black, true),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        book_data[index]['author'],
                        style: size(14.sp,
                            Colors.black.withOpacity(0.5), false),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          (book_data[index]['price']=='0') ? Text("free",style: size(15.sp, Colors.orange,true),): Text(" ${bloc.currencySymbol}",
                              style: size(14.sp, Colors.black, true)),
                          (book_data[index]['price']=='0') ? const SizedBox():Text(" ${book_data[index]['pricedrop']}",
                              style: TextStyle(fontSize: 14.sp,decoration: TextDecoration.lineThrough)),
                          (book_data[index]['price']=='0') ? const SizedBox():Text(" ${book_data[index]['price']}",
                              style: size(14.sp, Colors.black, true)),
                          /*Text("${bloc.currencySymbol} ${book_data[index]['price'].toString()}",
                              style: size(14.sp, Colors.black, true)),*/
                          SizedBox(
                            width: 5.w,
                          ),
                          RatingBar.builder(
                            ignoreGestures: true,
                            itemSize: 20,
                            initialRating: book_data[index]['star'] ?? 0,
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
                      Text(
                       book_data[index]['description'],style: size(15.sp, Colors.black, false),
                        maxLines: 2,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}
