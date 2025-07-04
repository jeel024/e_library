import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../config/theme.dart';
import '../supportive/bookview.dart';
import '../../../../../config/contants/variable_const.dart';
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  List search_data = [];
  List k = [];
  bool temp = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bloc = BlocProvider.of<AuthBloc>(context);
    search_data = bloc.book_data;
    k  = List.generate(bloc.book_data.length, (index) => index);
  }
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:   Column(
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.orange),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.grey),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      Expanded(
                        child: TextField(onChanged: (value) {
                          search_data = bloc.book_data
                              .where((element) =>
                          element['name'].toString().toLowerCase().trim().contains(value.toLowerCase().trim()) ||
                              element['author'].toString().toLowerCase().trim().contains(value.toLowerCase().trim()))
                              .toList();


                          k = [];
                          for(int i=0;i<bloc.book_data.length;i++)
                          {
                            for(int j=0;j<search_data.length;j++)
                            {
                              if(search_data[j]['id'] == bloc.book_data[i]['id'])
                              {
                                k.add(i);
                              }
                            }
                          }

                          setState(() {});

                        },
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: "  Search by Book / Author's name",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          search_data = bloc.book_data;
                          k  = List.generate(bloc.book_data.length, (index) => index);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                (search_data.isEmpty) ? Center(
                  child: Column(
                    children: [

                      Lottie.asset('images/search.json',height: 250.sp, reverse: true),
                      const Text("No Result found",style: TextStyle(fontSize: 20,color: Colors.orange)),
                    ],
                  ),
                ) :Column(children: List.generate(search_data.length ,(index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => BookView(search_data[index]));
                        },
                        child: Container(
                          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: CachedNetworkImageProvider(search_data[index]['image'].toString().replaceAll('localhost', '$ip'))),
                              color: Colors.orange.shade100,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          width: 90.w,
                          height: 110.h,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(width: 220.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              search_data[index]['name'],
                              style: size(15.sp, Colors.black, true),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              search_data[index]['author'],
                              style: size(14.sp,
                                  Colors.black.withOpacity(0.5), false),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: [
                                (search_data[index]['price']=='0') ? Text("free",style: size(15.sp, Colors.orange,true),): Text(" ${bloc.currencySymbol}",
                                    style: size(13.sp, Colors.black, false)),
                                (search_data[index]['price']=='0') ? const SizedBox():Text(" ${search_data[index]['pricedrop']}",
                                    style: TextStyle(fontSize: 13.sp,decoration: TextDecoration.lineThrough)),
                                (search_data[index]['price']=='0') ? const SizedBox():Text(" ${search_data[index]['price']}",
                                    style: size(13.sp, Colors.black, false)),
                                SizedBox(
                                  width: 5.w,
                                ),
                                RatingBar.builder(
                                  ignoreGestures: true,
                                  itemSize: 20,
                                  initialRating: search_data[index]['star'] ?? 0,
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
                              search_data[index]['description'],style: size(15.sp, Colors.black, false),
                              maxLines: 2,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),),
              ],
            )
          ),
        ),
      ),
    );
  }
}
