
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../bloc/auth/auth_bloc.dart';
import '../../../../bloc/logic_bloc/logic_bloc.dart';
import '../../../../config/contants/variable_const.dart';

clear(BuildContext context) {
  final bloc = BlocProvider.of<LogicBloc>(context);

  Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  cn.gender.value = '';
  cn.cntry.value = '';
  bloc.cfi = '';
  bloc.show = false;
  bloc.date = '';
  bloc.cntry = '';
  bloc.discount = 0.0;
  bloc.cpradio = '';
  bloc.value = false;
  bloc.eye = false;
  bloc.get_ctgr = [];
  bloc.name = '';
  bloc.path = null;
  bloc.cfi = "";

  final bloc1 = BlocProvider.of<AuthBloc>(context);

  bloc1.liked_book = [];
  bloc1.book_data = [];
  bloc1.data = {};
  bloc1.download_books = [];
  bloc1.liked= false;
  bloc1.final_rate = [];
  bloc1.total_price = 0.0;
  bloc1.cart = [];
  bloc1.last = [];
  bloc1.purchased = [];
  bloc1.history = [];
  bloc1.free = [];
  bloc1.downloadURL = "";

}