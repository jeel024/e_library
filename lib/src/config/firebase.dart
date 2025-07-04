import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_library/main.dart';
import 'package:e_library/src/config/contants/variable_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/logic_bloc/logic_bloc.dart';
import '../features/auth/presentation/pages/login.dart';
import 'contants/snackbar.dart';

store_data(BuildContext context) {
  String id = Login.instanc.currentUser!.uid;

  final bloc = BlocProvider.of<LogicBloc>(context);
Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  final user = <String, dynamic>{
    'name': bloc.name,
    'dob': bloc.date,
    'country': bloc.cntry,
    "image": BlocProvider.of<AuthBloc>(context).downloadURL,
    'gender': cn.gender.value,
    'category': bloc.get_ctgr,
    'liked': BlocProvider.of<AuthBloc>(context).liked_book,
    'cart' : BlocProvider.of<AuthBloc>(context).cart,
    'purchased' : BlocProvider.of<AuthBloc>(context).purchased,
    'history' : BlocProvider.of<AuthBloc>(context).history,
    'free' : BlocProvider.of<AuthBloc>(context).free,
  };
  FirebaseFirestore.instance.collection('users').doc(id).set(user);

  BlocProvider.of<AuthBloc>(context).data = user;
}

get_data(BuildContext context) {
  Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  String id = Login.instanc.currentUser!.uid;
  var db = FirebaseFirestore.instance;
  final docRef = db.collection("users").doc(id);
  docRef.get().then(
    (DocumentSnapshot doc) {
      Map data = doc.data() as Map;
      final bloc = BlocProvider.of<LogicBloc>(context);

      bloc.name = data['name'];
      bloc.date = data['dob'];
      BlocProvider.of<AuthBloc>(context).downloadURL = data['image'];
      bloc.get_ctgr = data['category'];
      bloc.cntry = data['country'];
      cn.gender.value = data['gender'];
      BlocProvider.of<AuthBloc>(context).data = data;
      BlocProvider.of<AuthBloc>(context).liked_book = data['liked'];
      BlocProvider.of<AuthBloc>(context).cart = data['cart'];
      BlocProvider.of<AuthBloc>(context).purchased = data['purchased'];
      BlocProvider.of<AuthBloc>(context).history = data['history'];
      BlocProvider.of<AuthBloc>(context).free = data['free'];
      BlocProvider.of<AuthBloc>(context).total_price = BlocProvider.of<AuthBloc>(context).cart.fold(0, (sum, item) => sum + double.parse(item['price']));
    },
    onError: (e) => errorSnackbar("Error getting document: $e"),
  );
}

book_data(BuildContext context) {
  var db = FirebaseFirestore.instance;
  final docRef = db.collection("books").doc('a74xaGMVOOorA5uS4g8T');
  docRef.get().then(
    (DocumentSnapshot doc) {
      Map data = doc.data() as Map;
      final bloc = BlocProvider.of<AuthBloc>(context);
      bloc.book_data = data['book'];
      //bloc.liked = List.filled(bloc.book_data.length, false);

      /*for (int i = 0; i < bloc.liked_book.length; i++) {
        for (int j = 0; j < bloc.book_data.length; j++) {
          if (bloc.book_data[j]['id'] == bloc.liked_book[i]["id"]) {
            bloc.liked[j] = true;
            continue;
          }
        }
      }*/
      List<double> rate = [];
      List<int> total_review = [];

      rate = List.filled(bloc.book_data.length, 0.0);
      bloc.final_rate = List.filled(bloc.book_data.length, 0.0);
      total_review = List.filled(bloc.book_data.length, 0);

      for (int i = 0; i < bloc.book_data.length; i++) {
        List t = bloc.book_data[i]['review'];
        total_review[i] = t.length;
        for (int j = 0; j < t.length; j++) {
          rate[i] += t[j]['rating'].toDouble();
        }
        bloc.final_rate[i] = (rate[i] / t.length).toPrecision(1);
      }
      print(rate);
      print(total_review);
      print(bloc.final_rate);
    },
    onError: (e) => errorSnackbar("Error getting document: $e"),
  );
}



update_data(String id, List download_books,List last, BuildContext context) {
  String data = jsonEncode(download_books);
  String last1 = jsonEncode(last);
  String qry = " UPDATE Downloads set data = '$data' , last = '$last1' where id  = '${BlocProvider.of<AuthBloc>(context).userid}'  ";
  Splash.database!.rawInsert(qry).then((value) {

    get_data1(context);
  });
}

get_data1(BuildContext context) async {
  String get_data =
      "select * from Downloads where id = '${BlocProvider.of<AuthBloc>(context).userid}'";
  List data = await Splash.database!.rawQuery(get_data);

  var d = jsonDecode(data[0]['data']);
  var l = jsonDecode(data[0]['last']);

  BlocProvider.of<AuthBloc>(context).download_books = d;
  BlocProvider.of<AuthBloc>(context).last = l;

  print(BlocProvider.of<AuthBloc>(context).download_books);
  print("5555555555555555555555555555555555555555555555555");
  print(BlocProvider.of<AuthBloc>(context).last);
}
/*Future<void> downloadAndSaveEpub(
    BuildContext context, Map data, String url, int i) async {
  var path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  Directory dir = Directory(path);
  if (!await dir.exists()) {
    await dir.create();
  }
  String file = "epub${Random().nextInt(1000)}.epub";
  File f = File("${dir.path}/${file}");
  try {
    final response = await http.get(Uri.parse(url));

    final file = File(f.path);
    BlocProvider.of<LogicBloc>(context).path = file;
    await file.writeAsBytes(response.bodyBytes);

    String filePath = '';
    try {
      final response = await http.get(Uri.parse(data['image']));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        filePath = '${directory.path}/image${Random().nextInt(1000)}.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        print('Failed to save image. Response status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
    get_data1(context);

    final bloc = BlocProvider.of<AuthBloc>(context);

    print( bloc.download_books.length);

    Map seen = {'id': data['id'],'page' : 0,'scroll' : 0.0};
    bloc.last.add(seen);

    bloc.download_books.add({
      'id': data['id'],
      'name': data['name'],
      'image': filePath,
      'by': data['by'],
      'path': f.path
    });

    bloc.downloaded_books.add({'id': data['id'], 'location': f.path});
    bloc.dl[i] = f.path;
    bloc.add(Download(i, f.path));
    update_data(Login.instanc.currentUser!.uid, bloc.download_books,bloc.last, context);

    store_data(context);
  } catch (e) {
    errorSnackbar('Error downloading EPUB file: $e');
  }
}*/
/*Future<void> saveImageFromUrl(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/image${Random().nextInt(1000)}.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);


    } else {
      errorSnackbar('Failed to save image. Response status: ${response.statusCode}');
    }
  } catch (e) {
    errorSnackbar('An error occurred: $e');
  }
}*/
