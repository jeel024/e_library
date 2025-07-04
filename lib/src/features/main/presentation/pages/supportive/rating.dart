import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_library/src/config/contants/button.dart';
import 'package:e_library/src/config/contants/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../config/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
class Rating extends StatelessWidget {
  Map data;
  Rating(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController comment = TextEditingController();
    double rating = 3.0;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: FileImage(File(data['image']))),
                  color: Colors.orange.shade100,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              width: 110.w,
              height: 120.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              data['name'],
              style: size(17.sp, Colors.black, true),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("By : ",
                    style: size(
                      15.sp,
                      Colors.black.withOpacity(0.4),
                      false,
                    )),
                Text(
                  data['by'],
                  style: size(16.sp, Colors.orange, false),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Rate this Book",
              style: size(15.sp, Colors.black, true),
            ),
            SizedBox(
              height: 5.h,
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating1) {
                rating = rating1;
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: CupertinoTextField(keyboardType: TextInputType.text,
                cursorColor: Colors.orange,
                controller: comment,
                placeholder: "Leave a comment",
                maxLines: 7,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: InkWell(
                onTap: () async {
                  if(comment.text.isEmpty)
                    {
                      errorSnackbar("Please leave a comment");
                    }
                  else
                    {
                      Map m = {
                        'bookId' : data['id'],
                        'userId': BlocProvider.of<AuthBloc>(context).userid,
                        'name': BlocProvider.of<AuthBloc>(context).getProfile!.fullName.toString(),
                        'rating': rating,
                        "comment": comment.text
                      };
                      BlocProvider.of<AuthBloc>(context).add(CreateReview(m));
                      Navigator.pop(context);

                      /*final DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('books')
                          .doc('a74xaGMVOOorA5uS4g8T');

                      final DocumentSnapshot documentSnapshot = await documentReference.get();
                      final existingData = documentSnapshot.data() as Map<String, dynamic>?;

                      final List<dynamic>? books =
                      existingData?['book'] as List<dynamic>?;
                      int temp = 0;
                      if (books != null && books.isNotEmpty) {
                        for(int i =0 ;i<books.length;i++)
                        {
                          if(books[i]['id'] == data['id'])
                          {
                            temp = i ;
                          }
                        }
                        final Map<String, dynamic>? firstBook =
                        books[temp] as Map<String, dynamic>?;
                        final List<dynamic>? firstBook1 =
                        books[temp]['review'] as List<dynamic>?;
                        firstBook1!.add(m);
                        if (firstBook != null) {
                          firstBook['review'] = firstBook1;

                          await documentReference.set({
                            'book': books,
                          }, SetOptions(merge: true));
                          final bloc = BlocProvider.of<AuthBloc>(context);
                          int i = 0;
                          for(i=0;i<bloc.book_data.length;i++)
                            {
                              if(data['id'] == bloc.book_data[i]['id'])
                                {
                                  bloc.book_data[i]['review'] = firstBook1;
                                  break;
                                }
                            }
                          double cnt = 0;
                          for(int i= 0 ;i<firstBook1.length;i++){
                            cnt+=firstBook1[i]['rating'];
                          }
                          bloc.final_rate[i] = (cnt/firstBook1.length).toPrecision(1);
                          Get.back();
                        }
                      }*/
                    }
                },
                child: button("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
