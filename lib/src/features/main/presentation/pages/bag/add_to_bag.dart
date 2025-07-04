import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_library/src/config/contants/button.dart';
import 'package:e_library/src/config/contants/variable_const.dart';
import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';
import 'package:e_library/src/features/main/presentation/pages/supportive/coupan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../bloc/auth/auth_state.dart';
import '../../../../../bloc/logic_bloc/logic_bloc.dart';
import '../../../../../config/contants/snackbar.dart';
import '../../../../../config/theme.dart';
import '../../../../auth/presentation/pages/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class AddToBag extends StatefulWidget {
  const AddToBag({Key? key}) : super(key: key);

  @override
  State<AddToBag> createState() => _AddToBagState();
}

class _AddToBagState extends State<AddToBag> {
  Mycontroll cn = Get.put(Mycontroll(), permanent: true);
  late Razorpay _razorpay;
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  /* void openCheckout(double amt) async {
    var options = {
      'key': 'rzp_test_5HZXNPrGXApOIO',
      //'key': 'rzp_test_5epmXyINi6bH4X',
      'amount': amt,
      'name': 'jeel',
      'description': 'Payment',
      'prefill': {'contact': '9054818700', 'email': 'jeelpipaliya024@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try
    {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }*/

  Future<void> _createOrder() async {
    final bloc = BlocProvider.of<AuthBloc>(context);

    print(json.encode({
      'amount': (bloc.total_price - BlocProvider.of<LogicBloc>(context).discount),
      'currency' : bloc.currency,
      'userId': bloc.userid
    }));
    final url = 'http://$ip:4000/api/order';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': (bloc.total_price - BlocProvider.of<LogicBloc>(context).discount),
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
        'amount':  (bloc.total_price - BlocProvider.of<LogicBloc>(context).discount) *
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
    print(response1.body);
    final data = json.decode(response1.body);
    final message = data['message'];

    debugPrint('Payment Verification: $message');

    successSnackbar("success");


  }

  void handlePaymentError(PaymentFailureResponse response) {
    errorSnackbar('Payment Error: ${response.message}');
    // Handle payment failure
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    errorSnackbar('External Wallet: ${response.walletName}');
    // Handle external wallet selection
  }



  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100.h,
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: size(18.sp, Colors.black, true),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Text(
                        "${bloc.currencySymbol} ${bloc.total_price - BlocProvider.of<LogicBloc>(context).discount}",
                        style: size(18.sp, Colors.black, true),
                      );
                    },
                  )
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              InkWell(
                onTap: () {
                  if (bloc.total_price == 0.0) {
                    errorSnackbar("No books selected");
                  } else {
                    //openCheckout((bloc.total_price - BlocProvider.of<LogicBloc>(context).discount)*100);
                    _createOrder();
                  }
                },
                child: button("Make Payment"),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: size(20.sp, Colors.orange, true),
        backgroundColor: Colors.grey[50],
        title: const Text("My Bag"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return (bloc.cart.isEmpty)
                ? Center(
                    child: Column(
                      children: [
                        Lottie.asset('images/search.json',
                            height: 250.sp, reverse: true),
                        const Text("No Books found",
                            style:
                                TextStyle(fontSize: 20, color: Colors.orange)),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: bloc.cart.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: CachedNetworkImageProvider(bloc
                                          .cart[index][0]['image']
                                          .toString()
                                          .replaceAll(
                                              'localhost', '$ip'))),
                                  color: Colors.orange.shade100,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              width: 70.w,
                              height: 80.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 240.w,
                              height: 80.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bloc.cart[index][0]['name'],
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
                                        bloc.cart[index][0]['author'],
                                        style:
                                            size(16.sp, Colors.orange, false),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${bloc.currencySymbol} ${bloc.cart[index][0]['price']}",
                                        style: size(18.sp, Colors.black, true),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(Cart(bloc.cart[index][0]));
                                        },
                                        child: Text(
                                          "Remove",
                                          style: size(16.sp, Colors.red, false),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
