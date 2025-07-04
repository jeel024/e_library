import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_state.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/theme.dart';
import '../supportive/bookview.dart';
import '../supportive/see_all.dart';

con(BuildContext context) {
  final bloc = BlocProvider.of<AuthBloc>(context);
  return Container(
    child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " Explore Books",
                    style: size(17.sp, Colors.black, true),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const SeeAll());
                      },
                      child:
                      Text("see all", style: size(15.sp, Colors.orange, false)),
                    ),
                  )
                ],
              ),
              Container(
                height: 210.h,
                child: BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    return ListView.builder(
                  itemCount: bloc.book_data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: SizedBox(width: 110.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(alignment: Alignment.topRight, children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => BookView(bloc.book_data[index]));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: CachedNetworkImageProvider(
                                          bloc.book_data[index]['image']
                                              .toString()
                                              .replaceAll(
                                              'localhost', ip)),
                                    ),
                                    color: Colors.orange.shade100,
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  width: 110.w,
                                  height: 120.h,
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(8.sp),
                              //   child: BlocBuilder<AuthBloc, AuthState>(
                              //     builder: (context, state) {
                              //       return FavoriteButton(
                              //         iconSize: 10,
                              //         isFavorite: bloc.liked[index],
                              //         valueChanged: (isFavorite) {
                              //           BlocProvider.of<AuthBloc>(context)
                              //               .add(Liked(bloc.book_data[index]));
                              //           if (isFavorite) {
                              //             bloc.liked[index] = true;
                              //           } else {
                              //             bloc.liked[index] = false;
                              //           }
                              //         },
                              //       );
                              //     },
                              //   ),
                              // ),
                            ]),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              bloc.book_data[index]['name'], maxLines: 2,
                              style: size(14.sp, Colors.black, true),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              bloc.book_data[index]['author'],
                              style:
                              size(12.sp, Colors.black.withOpacity(0.5), false),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (bloc.book_data[index]['price']=='0') ? Text("free",style: size(15.sp, Colors.orange,true),): Text(" ${bloc.currencySymbol}",
                                        style: size(13.sp, Colors.black, false)),
                                    (bloc.book_data[index]['price']=='0') ? const SizedBox():Text(" ${bloc.book_data[index]['pricedrop']}",
                                        style: TextStyle(fontSize: 13.sp,decoration: TextDecoration.lineThrough)),
                                    (bloc.book_data[index]['price']=='0') ? const SizedBox():Text(" ${bloc.book_data[index]['price']}",
                                        style: size(13.sp, Colors.black, false)),
                                  ],
                                ),

                              ],
                            ),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {

                                if (state is AuthLoading) {
                                  return const Text("");
                                }
                                return Text(
                                  (bloc.book_data[index]['star']==null) ? "⭐0.0":" ⭐${bloc.book_data[index]['star']}",
                                  style: size(13.sp, Colors.black, false),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
  },
),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.to(() => const SeeAll());
                      },
                      child: Text(
                        "Recommended Books",
                        style: size(17.sp, Colors.black, true),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const SeeAll());
                      },
                      child:
                      Text("see all", style: size(15.sp, Colors.orange, false)),
                    ),
                  )
                ],
              ),
               Container(
                height: 210.h,
                child: BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    return ListView.builder(
                  itemCount: bloc.recommended.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: SizedBox(width: 110.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(alignment: Alignment.topRight, children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => BookView(bloc.recommended[index]));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: CachedNetworkImageProvider(
                                          bloc.recommended[index]['image']
                                              .toString()
                                              .replaceAll(
                                              'localhost', ip)),
                                    ),
                                    color: Colors.orange.shade100,
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  width: 110.w,
                                  height: 120.h,
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(8.sp),
                              //   child: BlocBuilder<AuthBloc, AuthState>(
                              //     builder: (context, state) {
                              //       return FavoriteButton(
                              //         iconSize: 10,
                              //         isFavorite: bloc.liked[index],
                              //         valueChanged: (isFavorite) {
                              //           BlocProvider.of<AuthBloc>(context)
                              //               .add(Liked(bloc.book_data[index]));
                              //           if (isFavorite) {
                              //             bloc.liked[index] = true;
                              //           } else {
                              //             bloc.liked[index] = false;
                              //           }
                              //         },
                              //       );
                              //     },
                              //   ),
                              // ),
                            ]),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              bloc.recommended[index]['name'], maxLines: 2,
                              style: size(14.sp, Colors.black, true),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              bloc.recommended[index]['author'],
                              style:
                              size(12.sp, Colors.black.withOpacity(0.5), false),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (bloc.recommended[index]['price']=='0') ? Text("free",style: size(15.sp, Colors.orange,true),): Text(" ${bloc.currencySymbol}",
                                        style: size(13.sp, Colors.black, false)),
                                    (bloc.recommended[index]['price']=='0') ? const SizedBox():Text(" ${bloc.recommended[index]['pricedrop']}",
                                        style: TextStyle(fontSize: 13.sp,decoration: TextDecoration.lineThrough)),
                                    (bloc.recommended[index]['price']=='0') ? const SizedBox():Text(" ${bloc.recommended[index]['price']}",
                                        style: size(13.sp, Colors.black, false)),
                                  ],
                                ),

                              ],
                            ),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return const Text("");
                                }
                                return Text(
                                  (bloc.recommended[index]['star']==null) ? " ⭐0.0":" ⭐${bloc.recommended[index]['star']}",
                                  style: size(13.sp, Colors.black, false),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
  },
),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.to(() => const SeeAll());
                      },
                      child: Text(
                        "Your Topics",
                        style: size(17.sp, Colors.black, true),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const SeeAll());
                      },
                      child:
                      Text("see all", style: size(15.sp, Colors.orange, false)),
                    ),
                  )
                ],
              ),
              Container(
                height: 210.h,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: bloc.topic.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: SizedBox(width: 110.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(alignment: Alignment.topRight, children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          BookView(bloc.book_data[index]));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: CachedNetworkImageProvider(
                                              bloc.topic[index]['image']
                                                  .toString()
                                                  .replaceAll(
                                                  'localhost', ip)),
                                        ),
                                        color: Colors.orange.shade100,
                                        border: Border.all(
                                            color: Colors.orange),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      width: 110.w,
                                      height: 120.h,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(8.sp),
                                  //   child: BlocBuilder<AuthBloc, AuthState>(
                                  //     builder: (context, state) {
                                  //       return FavoriteButton(
                                  //         iconSize: 10,
                                  //         isFavorite: bloc.liked[index],
                                  //         valueChanged: (isFavorite) {
                                  //           BlocProvider.of<AuthBloc>(context)
                                  //               .add(Liked(bloc.book_data[index]));
                                  //           if (isFavorite) {
                                  //             bloc.liked[index] = true;
                                  //           } else {
                                  //             bloc.liked[index] = false;
                                  //           }
                                  //         },
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                ]),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  bloc.topic[index]['name'], maxLines: 2,
                                  style: size(14.sp, Colors.black, true),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  bloc.topic[index]['author'],
                                  style:
                                  size(12.sp, Colors.black.withOpacity(0.5),
                                      false),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        (bloc.topic[index]['price']=='0') ? Text("free",style: size(15.sp, Colors.orange,true),): Text(" ${bloc.currencySymbol}",
                                            style: size(13.sp, Colors.black, false)),
                                        (bloc.topic[index]['price']=='0') ? const SizedBox():Text(" ${bloc.topic[index]['pricedrop']}",
                                            style: TextStyle(fontSize: 13.sp,decoration: TextDecoration.lineThrough)),
                                        (bloc.topic[index]['price']=='0') ? const SizedBox():Text(" ${bloc.topic[index]['price']}",
                                            style: size(13.sp, Colors.black, false)),
                                      ],
                                    ),

                                  ],
                                ),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    if (state is AuthLoading) {
                                      return const Text("");
                                    }
                                    return Text(
                                      (bloc.topic[index]['star']==null) ? " ⭐0.0":" ⭐${bloc.topic[index]['star']}",
                                      style: size(
                                          13.sp, Colors.black, false),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " Free Books",
                    style: size(17.sp, Colors.black, true),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const SeeAll());
                      },
                      child:
                      Text("see all", style: size(15.sp, Colors.orange, false)),

                    ),
                  )
                ],
              ),Container(
                height: 210.h,
                child: ListView.builder(
                  itemCount: bloc.free_book.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: SizedBox(width: 110.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(alignment: Alignment.topRight, children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => BookView(bloc.free_book[index]));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: CachedNetworkImageProvider(
                                          bloc.free_book[index]['image'].toString()
                                              .replaceAll(
                                              'localhost', ip)
                                              ),
                                    ),
                                    color: Colors.orange.shade100,
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  width: 110.w,
                                  height: 120.h,
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(8.sp),
                              //   child: BlocBuilder<AuthBloc, AuthState>(
                              //     builder: (context, state) {
                              //       return FavoriteButton(
                              //         iconSize: 10,
                              //         isFavorite: bloc.liked[index],
                              //         valueChanged: (isFavorite) {
                              //           BlocProvider.of<AuthBloc>(context)
                              //               .add(Liked(bloc.book_data[index]));
                              //           if (isFavorite) {
                              //             bloc.liked[index] = true;
                              //           } else {
                              //             bloc.liked[index] = false;
                              //           }
                              //         },
                              //       );
                              //     },
                              //   ),
                              // ),
                            ]),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              bloc.free_book[index]['name'], maxLines: 2,
                              style: size(14.sp, Colors.black, true),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              bloc.free_book[index]['author'],
                              style:
                              size(12.sp, Colors.black.withOpacity(0.5), false),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("free",
                                    style: size(15.sp, Colors.orange, false)),

                              ],
                            ),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return const Text("");
                                }
                                return Text(
                                  (bloc.free_book[index]['star']==null) ? " ⭐0.0":" ⭐${bloc.free_book[index]['star']}",
                                  style: size(13.sp, Colors.black, false),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )),
  );
}
