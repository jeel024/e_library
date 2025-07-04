// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../config/theme.dart';
// import '../../../../logic_bloc/logic_bloc.dart';
// import '../../../../logic_bloc/logic_event.dart';
// import '../../../../logic_bloc/logic_state.dart';
// import '../supportive/coupan.dart';
//
// class Pay extends StatelessWidget {
//   const Pay({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: InkWell(
//           onTap: () {
//
//           },
//           child: Container(
//             alignment: Alignment.center,
//             width: double.infinity,
//             height: 40.h,
//             decoration: BoxDecoration(
//                 color: Colors.orange, borderRadius: BorderRadius.circular(8)),
//             child: Text(
//               "Make Payment",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 17.sp),
//             ),
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.grey[50],
//         iconTheme: const IconThemeData(color: Colors.orange),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.orange.shade100,
//                         borderRadius: const BorderRadius.only(
//                             topRight: Radius.circular(10),
//                             bottomRight: Radius.circular(10))),
//                     width: 90.w,
//                     height: 110.h,
//                   ),
//                   SizedBox(
//                     width: 10.w,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Lion Down",
//                         style: size(18.sp, Colors.black, true),
//                       ),
//                       SizedBox(
//                         height: 5.h,
//                       ),
//                       Row(
//                         children: [
//                           Text("By : ",
//                               style: size(
//                                 15.sp,
//                                 Colors.black.withOpacity(0.4),
//                                 false,
//                               )),
//                           Text(
//                             "Struat Gibbs",
//                             style: size(16.sp, Colors.orange, false),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         "\$12.00",
//                         style: size(20.sp, Colors.black, true),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               ListTile(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Coupan(),
//                       ));
//                 },
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 iconColor: Colors.black,
//                 tileColor: Colors.orange.shade100,
//                 leading: const Icon(Icons.discount_outlined),
//                 title: Text(
//                   (BlocProvider.of<LogicBloc>(context).cpradio.isEmpty)
//                       ? "Apply Coupon"
//                       : "${BlocProvider.of<LogicBloc>(context).cpradio} Applied",
//                   style: size(17.sp, Colors.black, false),
//                 ),
//                 trailing: const Icon(Icons.arrow_forward_ios_rounded),
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               Text(
//                 "How would you like to pay",
//                 style: size(17.sp, Colors.black, false),
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               BlocBuilder<LogicBloc, LogicState>(
//                 builder: (context, state) {
//                   if (state is LogicLoading) {
//                     return const CircularProgressIndicator();
//                   } else if (state is LogicLoaded) {
//                     return ListTile(
//                       onTap: () {
//                         BlocProvider.of<LogicBloc>(context)
//                             .add(PaymentOptionRadio("card"));
//                       },
//                       leading: const Icon(
//                         Icons.credit_card_rounded,
//                         color: Colors.blue,
//                       ),
//                       trailing: Radio(
//                         activeColor: Colors.orange,
//                         value: "card",
//                         groupValue:
//                             BlocProvider.of<LogicBloc>(context).payoption,
//                         onChanged: (String? value) {},
//                       ),
//                       contentPadding: const EdgeInsets.all(10),
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                               color: (BlocProvider.of<LogicBloc>(context)
//                                           .payoption ==
//                                       "card")
//                                   ? Colors.orange
//                                   : Colors.black.withOpacity(0.3)),
//                           borderRadius: BorderRadius.circular(10)),
//                       title: Text(
//                         "Card Details",
//                         style: size(17.sp, Colors.black, false),
//                       ),
//                       subtitle: const Text("account number\nexpiry date"),
//                     );
//                   }
//                   return ListTile(
//                     onTap: () {
//                       BlocProvider.of<LogicBloc>(context)
//                           .add(PaymentOptionRadio("card"));
//                     },
//                     leading: const Icon(
//                       Icons.credit_card_rounded,
//                       color: Colors.blue,
//                     ),
//                     trailing: Radio(
//                       activeColor: Colors.orange,
//                       value: "card",
//                       groupValue: BlocProvider.of<LogicBloc>(context).payoption,
//                       onChanged: (String? value) {},
//                     ),
//                     contentPadding: const EdgeInsets.all(10),
//                     shape: RoundedRectangleBorder(
//                         side: BorderSide(
//                             color: (BlocProvider.of<LogicBloc>(context)
//                                         .payoption ==
//                                     "card")
//                                 ? Colors.orange
//                                 : Colors.black.withOpacity(0.3)),
//                         borderRadius: BorderRadius.circular(10)),
//                     title: Text(
//                       "Card Details",
//                       style: size(17.sp, Colors.black, false),
//                     ),
//                     subtitle: const Text("account number\nexpiry date"),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               BlocBuilder<LogicBloc, LogicState>(
//                 builder: (context, state) {
//                   if (state is LogicLoading) {
//                     return const CircularProgressIndicator();
//                   } else if (state is LogicLoaded) {
//                     return ListTile(
//                       onTap: () {
//                         BlocProvider.of<LogicBloc>(context)
//                             .add(PaymentOptionRadio("Paypal"));
//                       },
//                       leading: const Icon(
//                         Icons.paypal,
//                         color: Colors.blue,
//                       ),
//                       trailing: Radio(
//                         activeColor: Colors.orange,
//                         value: "Paypal",
//                         groupValue:
//                             BlocProvider.of<LogicBloc>(context).payoption,
//                         onChanged: (value) {},
//                       ),
//                       contentPadding: const EdgeInsets.all(10),
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                               color: (BlocProvider.of<LogicBloc>(context)
//                                           .payoption ==
//                                       "Paypal")
//                                   ? Colors.orange
//                                   : Colors.black.withOpacity(0.3)),
//                           borderRadius: BorderRadius.circular(10)),
//                       title: Text("Paypal",
//                           style: size(17.sp, Colors.black, false)),
//                     );
//                   }
//                   {
//                     return ListTile(
//                       onTap: () {
//                         BlocProvider.of<LogicBloc>(context)
//                             .add(PaymentOptionRadio("Paypal"));
//                       },
//                       leading: const Icon(
//                         Icons.paypal,
//                         color: Colors.blue,
//                       ),
//                       trailing: Radio(
//                         activeColor: Colors.orange,
//                         value: "Paypal",
//                         groupValue:
//                             BlocProvider.of<LogicBloc>(context).payoption,
//                         onChanged: (value) {},
//                       ),
//                       contentPadding: const EdgeInsets.all(10),
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                               color: (BlocProvider.of<LogicBloc>(context)
//                                           .payoption ==
//                                       "Paypal")
//                                   ? Colors.orange
//                                   : Colors.black.withOpacity(0.3)),
//                           borderRadius: BorderRadius.circular(10)),
//                       title: Text("Paypal",
//                           style: size(17.sp, Colors.black, false)),
//                     );
//                   }
//                 },
//               ),
//               SizedBox(
//                 height: 30.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Item Total",
//                     style: size(16.sp, Colors.black, false),
//                   ),
//                   Text(
//                     "\$${price[0]}",
//                     style: size(16.sp, Colors.black, false),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Coupon Discount",
//                     style: size(16.sp, Colors.black, false),
//                   ),
//                   Text(
//                     (BlocProvider.of<LogicBloc>(context).cpradio.isEmpty)
//                         ? "Apply Coupon"
//                         : "\$${BlocProvider.of<LogicBloc>(context).discount}",
//                     style: size(16.sp, Colors.orange, false),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               Divider(
//                 color: Colors.black.withOpacity(0.3),
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Total Price",
//                     style: size(18.sp, Colors.black, true),
//                   ),
//                   Text(
//                     "\$${price[0] - BlocProvider.of<LogicBloc>(context).discount}",
//                     style: size(18.sp, Colors.black, true),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
