import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_library/src/config/contants/snackbar.dart';
import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';
import 'package:e_library/src/features/main/presentation/pages/supportive/review_see_all.dart';
import 'package:e_library/src/features/main/presentation/pages/supportive/see_all.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../bloc/auth/auth_state.dart';
import '../../../../../bloc/logic_bloc/logic_bloc.dart';
import '../../../../../bloc/logic_bloc/logic_event.dart';
import '../../../../../bloc/logic_bloc/logic_state.dart';
import '../../../../../config/contants/button.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/theme.dart';
import 'package:http/http.dart' as http;
import 'openfile.dart';

class BookView extends StatefulWidget {
  Map? data1;

  BookView(this.data1, {super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  bool _isShow = false;

  Map data = {};
  String category = '';
  var status1;
  int i = 0;
  Mycontroll cn = Get.put(Mycontroll(), permanent: true);

  get_per() async {
    status1 = await Permission.manageExternalStorage.status;
    if (status1 == PermissionStatus.denied) {
      await Permission.manageExternalStorage.request();
    }
  }

  late Razorpay _razorpay;

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> _createOrder() async {
    final bloc = BlocProvider.of<AuthBloc>(context);

    print(json.encode({
      'amount': widget.data1?['price'],
      'currency' : bloc.currency,
      'userId': bloc.userid
    }));
    final url = 'http://$ip:4000/api/order';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': widget.data1?['price'],
        'currency' : bloc.currency,
        'userId': bloc.userid
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${bloc.token}'
      },
    );
    final data = json.decode(response.body);
    final orderId = data['id'];
    print('ORDER ID+++++++${orderId}');
    print(response.body);
    if (response.statusCode == 200) {
      final options = {
        'key': 'rzp_test_5epmXyINi6bH4X',
        'amount':  widget.data1?['price'] *
            100,
        'name': 'Your App Name',
        'order_id': orderId,
        'description': 'Payment for Services',
        'prefill': {
          'contact': '',
          'email': 'jeelpipaliya024@gmail.com'
        },
        'currency' : bloc.currency,
        'external': {
          'wallets': ['paytm']
        },
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint('Error: ${e.toString()}');
      }
    }
  }



  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    final bloc = BlocProvider.of<AuthBloc>(context);
    final paymentId = response.paymentId;
    final orderId = response.orderId;
    final signature = response.signature;
    print("-----------------------------------");
    print(json.encode(
        {'orderId': orderId, 'paymentId': paymentId, 'signature': signature}));
    print(BlocProvider.of<AuthBloc>(context).token);
    final url = 'http://$ip:4000/api/paymentSuccess';
    final response1 = await http.post(
        Uri.parse(url),
        body: json.encode(
            {'orderId': orderId, 'paymentId': paymentId, 'signature': signature,'userId': bloc.userid}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${bloc.token}'
        }
    );
    print("-----------------------------------");
    print(response1.statusCode);
    if(response1.statusCode == 200)
      {
        successSnackbar("success");
        bloc.purchased.add(widget.data1);
        cn.page.value = 1;
        cn.tab.value = 1;
        Get.offAll(() => const HomeScreen());
      }
    print(response1.body);






  }

  void handlePaymentError(PaymentFailureResponse response) {
    errorSnackbar('Payment Error: ${response.message}');
    // Handle payment failure
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    errorSnackbar('External Wallet: ${response.walletName}');
    // Handle external wallet selection
  }

  String id = "";

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    get_per();
    data = widget.data1!;


    BlocProvider.of<AuthBloc>(context).add(GetReview(data['id']));
    final bloc = BlocProvider.of<AuthBloc>(context);
    bloc.liked = false;
    for (i = 0; i < bloc.book_data.length; i++) {
      if (data['id'] == bloc.book_data[i]['id']) {
        break;
      }
    }

    for (int i = 0; i < data['category'].length; i++) {
      category += data['category'][i];
      category += " & ";
    }
    category = category.substring(0, category.length - 3);


    for (int i = 0; i < bloc.download_books.length; i++) {
      if (bloc.download_books[i]['id'] == data['id']) {
        id = bloc.download_books[i]['id'];
        for (int k = 0; k < bloc.last.length; k++) {
          if (bloc.last[k]['id'] == data['id']) {
            File f = File(bloc.download_books[i]['path']);
            BlocProvider.of<LogicBloc>(context).path = f;
            cn.current.value =
                BlocProvider.of<AuthBloc>(context).last[k]['page'];
            cn.last.value =
                BlocProvider.of<AuthBloc>(context).last[k]['scroll'];
            break;
          }
        }
      }
    }

    for(int j =0 ;j<bloc.liked_book.length;j++)
    {
      if(bloc.liked_book[j]['id'] == data['id'])
      {
        bloc.liked = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            _isShow ? data['name'] : "",
            style: size(20.sp, Colors.white, true),
          ),
          backgroundColor: _isShow ? Colors.orange : Colors.grey[50],
          iconTheme:
              IconThemeData(color: !_isShow ? Colors.orange : Colors.grey[50]),
          elevation: 0,
          actions: [
            (data['price']==0) ? const SizedBox():  InkWell(
              onTap: () {
                bool t = false;
                for (int i = 0; i < bloc.download_books.length; i++) {
                  if (data['id'] == bloc.download_books[i]['id']) {
                    t = true;
                    break;
                  }
                }
                if (bloc.cart.contains(data)) {
                  errorSnackbar("already in the cart");
                } else if (t == true) {
                  errorSnackbar("already downloaded");
                } else {
                  Map m = {
                    "userId": bloc.userid,
                    "books": [
                      {
                        "bookId": data['id'],
                        "name": data['name'],
                        "author": data['author'],
                        "price": data['price'],
                        "image" : data['image']
                      }
                    ]
                  };
                  bloc.add(PutCart(m));

                 /* bloc.cart.add(data);*/
             /*     bloc.total_price = bloc.cart.fold(
                      0, (sum, item) => sum + double.parse(item['price']));

*/
                  /*FirebaseFirestore.instance
                      .collection('users')
                      .doc(Login.instanc.currentUser!.uid)
                      .update({'cart': bloc.cart}).then(
                    (value) {

                    },
                  );*/
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                width: 25,
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(
                  top: 15, bottom: 15, right: 15, left: 10),
              width: 25,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return FavoriteButton(
                    iconSize: 10,
                    isFavorite: bloc.liked,
                    valueChanged: (isFavorite) {
                      String dltid = "";
                      for(int i =0 ;i<bloc.liked_book.length;i++)
                        {
                          if(bloc.liked_book[i]['id'] == data['id'])
                            {
                              dltid = bloc.liked_book[i]['whishid'];
                            }
                        }

                  data['bookId']= data['id'];


                      Map m = {
                        "userId": bloc.userid,
                        "books": [
                            data,
                        ]
                      };
                      BlocProvider.of<AuthBloc>(context).add(Liked(m,isFavorite,dltid));
                      if (isFavorite) {
                        bloc.liked= true;
                      } else {
                        bloc.liked = false;
                      }

                    },
                  );
                },
              ),
            )
          ]),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() => _isShow = false);
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() => _isShow = true);
          }
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(data['image']
                                  .toString()
                                  .replaceAll('localhost', ip))),
                          color: Colors.orange.shade100,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      width: 90.w,
                      height: 110.h,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      width: 220.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['name']}",
                            style: size(18.sp, Colors.black, true),
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
                                data['author'],
                                style: size(16.sp, Colors.orange, false),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text("Publisher : ",
                                  style: size(
                                    13.sp,
                                    Colors.black.withOpacity(0.4),
                                    false,
                                  )),
                              Text(
                                data['publisher'],
                                style: size(15.sp, Colors.black, false),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text("Language : ",
                                  style: size(
                                    13.sp,
                                    Colors.black.withOpacity(0.4),
                                    false,
                                  )),
                              Text(
                                data['language'],
                                style: size(15.sp, Colors.black, false),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Text("category : ",
                                  style: size(
                                    13.sp,
                                    Colors.black.withOpacity(0.4),
                                    false,
                                  )),
                              SizedBox(
                                width: 150.w,
                                child: Text(
                                  category,
                                  style: size(15.sp, Colors.black, false),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Rating",
                          style: size(
                              16.sp, Colors.orange.withOpacity(0.7), false),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          " ${data['star']} ⭐",
                          style: size(16.sp, Colors.black, false),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Downloads",
                          style: size(
                              16.sp, Colors.orange.withOpacity(0.7), false),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "${bloc.downloads} Reader",
                          style: size(16.sp, Colors.black, false),
                        ),
                      ],
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {

                            if (id == '') {
                              if(data['price'] == '0')
                              {
                                bloc.purchased.add(data);
                                cn.tab.value = 1;
                                cn.page.value = 1;
                                Get.offAll(() => const HomeScreen());
                              }
                              else{
                                _createOrder();
                              }

                            } else {
                              Get.to(() => OpenBook(id, true, ''));
                            }


                           /* if (id == '') {
                              if(data['price']==0)
                                {
                                  BlocProvider.of<AuthBloc>(context)
                                      .purchased
                                      .add(data);
                                  cn.page.value = 1;
                                  cn.tab.value = 1;
                                  Get.offAll(() => const HomeScreen());
                                }
                              else
                                {
                                  _createOrder();
                                }


                              // openCheckout((double.parse(data['price']) * 100));
                            } else {
                              Get.to(() => OpenBook(id, true, ''));
                            }*/
                            /*if (BlocProvider.of<AuthBloc>(context)
                                    .dl[i] ==
                                "") {
                              downloadAndSaveEpub(
                                  context, data, data['book'], i);
                            } else {
                              File f1 = File(BlocProvider.of<AuthBloc>(context)
                                  .dl[i]);
                              BlocProvider.of<LogicBloc>(context).path = f1;

                              int k = 0;

                              for (int i = 0; i < BlocProvider.of<AuthBloc>(context).last.length;i++)
                              {
                                if (data['id'] == BlocProvider.of<AuthBloc>(context).last[i]['id'])
                                {
                                  k = i;
                                  break;
                                }
                              }
                              cn.current.value = BlocProvider.of<AuthBloc>(context).last[k]['page'];
                              cn.last.value = BlocProvider.of<AuthBloc>(context).last[k]['scroll'];
                              print("object12346");
                              print(data['id']);
                              //BlocProvider.of<AuthBloc>(context).last[index] = {'page' : 0,'scroll' : 0.0}
                              Get.to(() => OpenBook(data['id'])); }*/
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 180.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5)),
                            child:
                            (id!="") ? Text("Read Now",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp,color: Colors.white),):Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text( " Download For ",style: TextStyle(fontSize: 15.sp,color: Colors.white,fontWeight: FontWeight.bold),),
                                Text((data['price']=="0") ? "":bloc.currencySymbol,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp,color: Colors.white)),
                              //  (data['price']=="0") ? const SizedBox(): Text("${data['pricedrop'].toString()} ",style: TextStyle(fontSize: 15.sp,color: Colors.white,decoration: TextDecoration.lineThrough)),
                                Text((data['price']=="0") ? "Free":data['price'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp,color: Colors.white)),
                              ],
                            )
                           /* Text(
                              (id == "")
                                  ? (data['price']=='0') ? "Download For Free":  (data['pricedrop'] != null) ?"Download For ${bloc.currencySymbol}${data['pricedrop']} ${data['price']}" :"Download For ${bloc.currencySymbol} ${data['price']}"
                                  : "Read Book",
                              style: TextStyle(fontSize: 15.sp,color: Colors.white,decoration: TextDecoration.lineThrough),
                            ),*/
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                (id == "")
                    ? (data['price']=='0') ? const SizedBox(): InkWell(
                        onTap: () {
                          if (bloc.free.contains(data['id'])) {
                            errorSnackbar("Already seen free demo");
                          } else {
                            //bloc.free.add(data['id']);
                            // FirebaseFirestore.instance
                            //     .collection('users')
                            //     .doc(Login.instanc.currentUser!.uid)
                            //     .update({'free': bloc.free});

                            Get.to(() =>
                                OpenBook(data['id'], false, data['book']));
                          }
                        },
                        child: button("See free Preview"),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: (id == "") ? 10.h : 0,
                ),
                BlocBuilder<LogicBloc, LogicState>(
                  builder: (context, state) {
                    return Text(
                      data['description'],
                      maxLines:
                          (!BlocProvider.of<LogicBloc>(context).show) ? 10 : 25,
                      style: size(16.sp, Colors.black, false),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    BlocProvider.of<LogicBloc>(context).add(
                        ShowMore(!BlocProvider.of<LogicBloc>(context).show));
                  },
                  child: BlocBuilder<LogicBloc, LogicState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (!BlocProvider.of<LogicBloc>(context).show)
                                ? "show more "
                                : "show less",
                            style: size(15, Colors.orange, true),
                          ),
                          Icon(
                            (!BlocProvider.of<LogicBloc>(context).show)
                                ? Icons.keyboard_arrow_down_outlined
                                : Icons.keyboard_arrow_up_outlined,
                            color: Colors.orange,
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: 330.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Publisher Detail's",
                              style: size(16.sp, Colors.orange, true),
                            ),
                            Text(
                              "Categories",
                              style: size(16.sp, Colors.orange, true),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['publisher'],
                              style: size(16.sp, Colors.black, false),
                            ),
                            Text(
                              category,
                              style: size(16.sp, Colors.black, false),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reviews",
                      style: size(20.sp, Colors.black, true),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(() =>
                              Review_SeeAll(data['review'], data['name']));
                        },
                        child: Text("see all",
                            style: size(15.sp, Colors.orange, false)))
                  ],
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoading)
                      {
                        return const Center(child: CircularProgressIndicator(),);
                      }
                    data['review'] = bloc.review;
                    return (data['review'].length==0) ? const Text("No Reviews yet"): SizedBox(
                      height: 135.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data['review'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(15)),
                            margin: const EdgeInsets.all(10),
                            width: 260.w,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['review'][index]['name'],
                                      style: size(18.sp, Colors.black, true),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RatingBar.builder(
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          itemSize: 20,
                                          initialRating: data['review'][index]
                                                  ['rating']
                                              .toDouble(),
                                          direction: Axis.horizontal,

                                          //itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (double value) {},
                                        ),
                                        Text(
                                          "${DateTime.parse(data['review'][index]['date']).day.toString()}/${DateTime.parse(data['review'][index]['date']).month.toString()}/${DateTime.parse(data['review'][index]['date']).year.toString()}",
                                          style: size(
                                              14.sp,
                                              Colors.black.withOpacity(0.5),
                                              false),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      data['review'][index]['comment'],
                                      maxLines: 3,
                                      style: size(15.sp, Colors.black, false),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Similar titles",
                      style: size(17.sp, Colors.black, true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const SeeAll());
                        },
                        child: Text("see all",
                            style: size(15.sp, Colors.orange, false)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                Container(
                  height: 210.h,
                  child: ListView.builder(
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
                                    (bloc.book_data[index]['star']==null) ? " ⭐0.0":" ⭐${bloc.book_data[index]['star']}",
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
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
          visible: _isShow,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, state) {
              return InkWell(
                onTap: () {
                  if (id == '') {
                    if(data['price'] == '0')
                      {
                        bloc.purchased.add(data);
                        cn.tab.value = 1;
                        cn.page.value = 1;
                        Get.offAll(() => const HomeScreen());
                      }
                    else{
                     _createOrder();
                    }

                  } else {
                    Get.to(() => OpenBook(id, true, ''));
                  }
                  // if (BlocProvider.of<AuthBloc>(context).dl[i] == "")
                  // {
                  //   downloadAndSaveEpub(context, data, data['book'], i)
                  //       .then(
                  //     (value) {
                  //       //BlocProvider.of<AuthBloc>(context).add(Download(i));
                  //     },
                  //   );
                  // } else
                  // {
                  //   File f1 =
                  //       File(BlocProvider.of<AuthBloc>(context).dl[i]);
                  //   BlocProvider.of<LogicBloc>(context).path = f1;
                  //
                  //   // File f = File(book[index]['path']);
                  //   // BlocProvider.of<LogicBloc>(context).path = f;
                  //   int k = 0;
                  //
                  //   for (int i = 0;
                  //       i < BlocProvider.of<AuthBloc>(context).last.length;
                  //       i++) {
                  //     print(data['id']);
                  //     print(BlocProvider.of<AuthBloc>(context).last[i]['id']);
                  //     if (data['id'] ==
                  //         BlocProvider.of<AuthBloc>(context).last[i]['id']) {
                  //       k = i;
                  //       break;
                  //     }
                  //   }
                  //   cn.current.value =
                  //       BlocProvider.of<AuthBloc>(context).last[k]['page'];
                  //   cn.last.value =
                  //       BlocProvider.of<AuthBloc>(context).last[k]['scroll'];
                  //   Get.to(() => OpenBook(data['id']));
                  // }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child:
                  Container(

                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: Colors.orange, borderRadius: BorderRadius.circular(5)),

                    child: (id!="") ? Text("Read Now",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp,color: Colors.white),):Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( " Download For ",style: TextStyle(fontSize: 17.sp,color: Colors.white,fontWeight: FontWeight.bold),),
                        Text((data['price']=="0") ? "":bloc.currencySymbol,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp,color: Colors.white)),
                        (data['price']=="0") ? const SizedBox(): Text("${data['pricedrop'].toString()} ",style: TextStyle(fontSize: 17.sp,color: Colors.white,decoration: TextDecoration.lineThrough)),
                        Text((data['price']=="0") ? "Free":data['price'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp,color: Colors.white)),
                      ],
                    ),
                  )
                ),
              );
            },
          )),
    );
  }
}
