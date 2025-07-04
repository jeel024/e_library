import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../config/theme.dart';

class Review_SeeAll extends StatelessWidget {
  List review = [];
  String name = '';

  Review_SeeAll(this.review, this.name, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange,
        title: Text(name),
      ),
      body: (review.isEmpty) ? Center(
          child: Column(
            children: [
              Lottie.asset('images/search.json',
                  height: 250.sp, reverse: true),
              Text("No Reviews Yet",
                  style: size(20.sp, Colors.orange, true)),
            ],
          )):ListView.builder(itemCount: review.length,itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(decoration: BoxDecoration(color: Colors.orange.shade50,borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.orange)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review[index]['name'],
                    style: size(18.sp, Colors.black, true),
                  ),
                  SizedBox(height: 5.h,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingBar.builder(
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemSize: 25,
                        initialRating: review[index]
                        ['rating']
                            .toDouble(),
                        direction: Axis.horizontal,

                        //itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                      Text("${DateTime.parse(review[index]['date']).day.toString()}/${DateTime.parse(review[index]['date']).month.toString()}/${DateTime.parse(review[index]['date']).year.toString()}",style: TextStyle(color: Colors.black.withOpacity(0.5)),)

                    ],
                  ),
                  SizedBox(height: 5.h,),
                  Text(
                    review[index]['comment'],
                    maxLines: 3,
                    style: size(15.sp, Colors.black, false),
                  )
                ],
              ),
            ),
          ),
        );
      },),
    );
  }
}
