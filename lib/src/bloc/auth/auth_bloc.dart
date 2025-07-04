import 'dart:convert';
import 'package:e_library/src/config/contants/variable_const.dart';
import 'package:e_library/src/features/auth/presentation/pages/category.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:e_library/main.dart';
import 'package:e_library/src/config/contants/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/auth/presentation/pages/gender.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/main/presentation/pages/home/homescreen.dart';
import '../../model/book_model.dart';
import '../../model/get_profile_model.dart';
import '../../model/getgender_model.dart';
import '../../model/reviews_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:path/path.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<Google_Signin>(_google_sign_in);
    on<Sign_out>(_sign_out);
    on<Email_Signin>(_email_signin);
    on<Email_Login>(_email_Login);
    on<Liked>(_liked);
    on<Cart>(_cart);
    on<Purchased>(_purchased);
    on<StoreImage>(_storeImage);
    on<StoreGender>(storegender);
    on<Bookdata>(bookdata);
    on<UpdateCategory>(updatecategory);
    on<UpdateProfile>(updateprofile);
    on<CreateReview>(createReview);
    on<GetReview>(getreview);
    on<PutCart>(putcart);
    on<ForgrtPassword>(forgetPassword);
    on<Cntry>(cntry);
  }

  Mycontroll cn = Get.put(Mycontroll(), permanent: true);
  Map data = {};
  List book_data = [];
  List download_books = [];
  List liked_book = [];
  bool liked = false;

  List last = [];
  List cart = [];
  double total_price = 0.0;
  List purchased = [];
  List history = [];
  List free = [];
  String userid = "";
  String token = "";
  String username = "";
  List topic = [];
  List recommended = [];
  String currencySymbol = "";
  String currency = "";
  List free_book  = [];

  _google_sign_in(Google_Signin event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
     /* GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleuser!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await Login.instanc.signInWithCredential(credential);*/

    } catch (e) {
      errorSnackbar(e.toString());
      emit(AuthError());
    }
  }

  _sign_out(Sign_out event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      Box box = Hive.box("data");
      box.put('login', false);

      Get.offAll(() => const Login());
     /* if (await GoogleSignIn().isSignedIn()) {
        GoogleSignIn().disconnect();
      }
      await Login.instanc.signOut();

      if (Login.instanc.currentUser == null) {
        Get.offAll(() => const Login());
      } else {
        errorSnackbar("can't logout ");
      }*/
      emit(AuthLoaded());
    } catch (e) {
      errorSnackbar(e.toString());
      emit(AuthError());
    }
  }

  _email_signin(Email_Signin event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      try {
        username = event.name;
        var url = Uri.parse('http://$ip:4000/api/adduser');
        http.Response response1 = await http.post(url, body: {
          'name': event.name,
          'email': event.email,
          'password': event.pass
        });

        Map rsp = json.decode(response1.body);

        String msg = rsp['message'];
        if (msg == "Mail exists") {
          errorSnackbar(msg);
        } else {
          Get.defaultDialog(
            middleText:
                "We have sent verification request to your mail.. It may be in spam",
            confirmTextColor: Colors.orange,
            cancel: TextButton(
                onPressed: () async {
                  await launch("https://mail.google.com/");
                },
                child: const Text(
                  "Open Gmail",
                  style: TextStyle(fontSize: 17, color: Colors.orange),
                )),
            title: "Verification !!",
          );
        }

      } on FirebaseAuthException catch (e) {
        errorSnackbar(e.toString());
      }
      emit(AuthLoaded());
    } catch (e) {
      emit(AuthError());
    }
  }

  BookModel? bookModel;
  GetGenderData? genderModel;

  get_gender() async {
    http.Response response = await http.get(
        Uri.parse("http://$ip:4000/api/getCategory/$userid"),
        headers: {'Authorization': 'Bearer ${data['token']}'});

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) {
        Get.off(() => const Gender());
      } else {
        genderModel = GetGenderData.fromJson(json.decode(response.body));
        Get.offAll(() => const HomeScreen());
      }
    }
  }

  _email_Login(Email_Login event, Emitter<AuthState> emit) async {
    try {
    emit(AuthLoading());

    http.Response response1 = await http.post(
        Uri.parse("http://$ip:4000/api/signin"),
        body: {'email': event.email, 'password': event.pass});
    Map data = json.decode(response1.body);
    userid = data['user']['id'];
    username = data['user']['name'];
    token = data['token'];

    Box box = Hive.box("data");
    box.put('userToken', data['token']);
    box.put('userId', data['user']['id']);
    box.put('image', data['user']['image']);
    downloadURL = data['user']['image'];
    box.put('login', true);
    insert_data(userid);
    http.Response response = await http.get(
        Uri.parse("http://$ip:4000/api/getCategory/$userid"),
        headers: {'Authorization': 'Bearer ${data['token']}'});

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) {
        Get.off(() => const Gender());
      } else {
        genderModel = GetGenderData.fromJson(json.decode(response.body));
        Get.offAll(() => const HomeScreen());
      }
    }
    emit(AuthLoaded());
    } catch (e) {
      errorSnackbar(e.toString());
      emit(AuthError());
    }
  }

  _liked(Liked event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      if (!event.isliked) {
        //liked_book.remove(event.data);
        http.Response response = await http.delete(
            Uri.parse("http://$ip:4000/api/removeBook/wishlist/$userid"),
            body: json.encode({
              'id': event.wid,
            }),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            });
        successSnackbar("Removed from Whishlist");
      } else {
        //liked_book.add(event.data);


        http.Response response = await http.put(
            Uri.parse("http://$ip:4000/api/wishlist/$userid"),
            body: json.encode(event.data),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            });

        successSnackbar("Added to Whishlist");
      }
      getwhishlist();
      /*FirebaseFirestore.instance
          .collection('users')
          .doc(Login.instanc.currentUser!.uid)
          .update({'liked': liked_book});*/

      emit(AuthLoaded());
    } catch (e) {
      errorSnackbar("can't download ");
      emit(AuthError());
    }
  }

  _cart(Cart event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      //cart.remove(event.data);
      http.Response response = await http.delete(
          //192.168.255.252
          Uri.parse("http://$ip:4000/api/deleteCart/$userid"),
          body: json.encode({
            'id': event.data['cartid'],
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      /*FirebaseFirestore.instance
          .collection('users')
          .doc(Login.instanc.currentUser!.uid)
          .update({'cart': cart});*/
      getcart();

      /*total_price =
          cart.fold(0, (sum, item) => sum + double.parse(item['price']));*/
      emit(AuthLoaded());
    } catch (e) {
      errorSnackbar("can't remove ");
      emit(AuthError());
    }
  }

  _purchased(Purchased event, Emitter<AuthState> emit) {
    try {
      emit(AuthLoading());
      if (purchased.contains(event.m)) {
        purchased.remove(event.m);
      }

      emit(AuthLoaded());
    } catch (e) {
      errorSnackbar("can't remove ");
      emit(AuthError());
    }
  }

  var downloadURL = '';

  _storeImage(StoreImage event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      var request = http.MultipartRequest(
          'PUT', Uri.parse('http://$ip:4000/api/updateProfileImage/$userid'));
      request.headers['Authorization'] = 'Bearer $token';
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        event.image!.path,
        filename: event.image!.path.split("/").last,
        contentType: MediaType.parse('image/jpg'),
      );
      try {
        request.files.add(multipartFile);
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          List m = json.decode(responseData);

          Box box = Hive.box("data");
          box.put('image', m[0]['image']);
          downloadURL = m[0]['image'];
          Get.back();
          emit(AuthLoaded());
        }
      } catch (e, s) {
      }
    } catch (e, s) {
      emit(AuthError());
    }
  }

  storegender(StoreGender event, Emitter<AuthState> emit) async {
    try
    {
    emit(AuthLoading());
    http.Response response = await http.post(
        //192.168.255.252
        Uri.parse("http://$ip:4000/api/category/gender"),
        body: json.encode({
          'userId': userid,
          "gender": cn.gender.value,
          "category": cn.ctgy.value
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      Box box = Hive.box("data");
      box.put('login', true);
      Get.offAll(() => const HomeScreen());
    }
    emit(AuthLoaded());
    }
    catch (e)
     {
       errorSnackbar("can't store data please try again");
       emit(AuthLoading());
     }
  }

  Review? reviewModel;
  List review = [];
  List final_rate = [];

  get_review() async {
    emit(AuthLoading());
    final_rate = List.filled(book_data.length, 0.0);
    for (int i = 0; i < book_data.length; i++) {
      http.Response response = await http.get(
          Uri.parse("http://$ip:4000/api/review/${book_data[i]['id']}"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      //print(response.body);
      Map m = json.decode(response.body);
      review = m['reviews'];

      List<double> rate = [];
      List<int> totalReview = [];

      rate = List.filled(book_data.length, 0.0);
      totalReview = List.filled(book_data.length, 0);


if(review.isNotEmpty)
  {
    List t = review;
    totalReview[i] = t.length;
    for (int j = 0; j < t.length; j++) {
      rate[i] += t[j]['rating'].toDouble();
    }
    final_rate[i] = (rate[i] / t.length).toPrecision(1);
    book_data[i]['star'] = (rate[i] / t.length).toPrecision(1);
  }

    }

    emit(AuthLoaded());
  }

  gethistory()
  async {
    http.Response response = await http
        .get(Uri.parse("http://$ip:4000/api/getDownloadByUserId/$userid"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    List ct = json.decode(response.body);

history = [];
    for(int i =0 ;i<ct.length;i++)
      {
        for(int j=0;j<book_data.length;j++)
          {
            if(ct[i]['bookId'] == book_data[j]['id'])
              {
                history.add(book_data[j]);
                history[history.length-1]['time'] = ct[i]['createdAt'];
              }
          }
      }

  }

  getwhishlist() async {
    try {
      emit(AuthLoading());

      http.Response response = await http
          .get(Uri.parse("http://$ip:4000/api/getWishlist/$userid"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      List ct = json.decode(response.body);


      liked_book = [];
      for (int i = 0; i < ct.length; i++) {

        liked_book.add(ct[i]['books'][0]);
        liked_book[i]['whishid'] = ct[i]['id'];


      }
      /*for (int i = 0; i < ct[i]['books'].length; i++) {
        liked_book.add(ct[i]['books']);
        //liked_book[i]['whishid'] = ct[i]['id'];
        print(ct[i]['id']);
        //print(liked_book[i]['whishid']);
      }*/

      emit(AuthLoaded());
    } catch (e) {
      emit(AuthError());
    }
  }

  GetProfile? getProfile;

  bookdata(Bookdata event, Emitter<AuthState> emit) async {
   /* try
    {*/
    emit(AuthLoading());
    http.Response response = await http.get(
        //192.168.255.252
        Uri.parse("http://$ip:4000/api/getFile"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    book_data = json.decode(response.body) as List;

    book_data = book_data.reversed.toList();
    for (int i = 0; i < book_data.length; i++) {
      book_data[i]['category'] =
          json.decode(book_data[i]['category']).cast<String>().toList();
    }
   // liked = List.filled(book_data.length, false);


    http.Response response6 = await http.get(
        Uri.parse("http://$ip:4000/api/getCategory/$userid"),
        headers: {'Authorization': 'Bearer $token'});

    genderModel = GetGenderData.fromJson(json.decode(response6.body));
    http.Response response1 = await http.get(
        //192.168.255.252
        Uri.parse("http://$ip:4000/api/profile/$userid"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response1.statusCode == 200) {
      List m = json.decode(response1.body);

      var l = json.encode(m[0]);
      getProfile = GetProfile.fromJson(json.decode(l));

      final url1 = 'https://restcountries.com/v3.1/name/${getProfile!.country}?fullText=true';
      final response12 = await http.get(Uri.parse(url1));
      final responseData1 = json.decode(response12.body);
      final currencies = responseData1[0]['currencies'] as Map<String, dynamic>;

       currency = currencies.keys.first;
      print(currency);

      const url = 'https://api.exchangerate-api.com/v4/latest/INR';
      final responded = await http.get(Uri.parse(url));
      final responseData = json.decode(responded.body);

      Map  _exchangeRates = Map.from(responseData['rates']);
      var convertedValue =  _exchangeRates[currency];

      print(convertedValue);

      for(int i = 0;i<book_data.length;i++)
      {
        print(book_data[i]['price']);
        double d =  (convertedValue * double.parse(book_data[i]['price'].toString()));
        if(book_data[i]['price'] != "0")
          {
            if(i<3)
            {
              book_data[i]['pricedrop'] = d.toPrecision(2);
              book_data[i]['price'] = "${(d*0.90).toPrecision(2)}";
            }
            else
            {
              book_data[i]['price'] = d.toPrecision(2);
              book_data[i]['pricedrop'] = "";
            }
          }


      }
      String s = "";
      if(getProfile!.country.toString() == "United States")
        {
          s = "United States of America";
        }
      else
        {
          s = getProfile!.country;
        }
      final url2 = 'https://restcountries.com/v2/name/$s';
      print(url2);
      final response = await http.get(Uri.parse(url2));

      final responseData2 = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 && responseData2 is List && responseData2.isNotEmpty) {
        for(int i = 0;i<responseData2.length;i++)
          {

            if(responseData2[i]['name'].toString().toLowerCase() == s.toLowerCase())
              {
                final currencies1 = responseData2[i]['currencies'] as List<dynamic>;
                if (currencies1.isNotEmpty) {
                  final symbol = currencies1[0]['symbol'];

                   currencySymbol = symbol != null ? symbol.toString() : 'Currency symbol not available';
                  print(currencySymbol);

                }
              }
          }
        }
      get_review();
      getcart();
      getwhishlist();
      gethistory();
      recommended = [];
      recommended = List.from(book_data);
      recommended.shuffle();

      free_book = [];
      for(int i =0 ;i<book_data.length;i++)
        {
          if(book_data[i]['price'] == "0")
            {
              free_book.add(book_data[i]);
            }
        }




    } else {
    }
    emit(AuthLoaded());
    /*}
    catch (e)
     {
       errorSnackbar("can't retrieve book data");
       emit(AuthError());
     }*/
  }

  updatecategory(UpdateCategory event, Emitter<AuthState> emit) async {
    try
    {
    emit(AuthLoading());
    http.Response response = await http.put(
        //192.168.255.252
        Uri.parse("http://$ip:4000/api/update/category/$userid"),
        body: json.encode({'category': cn.ctgy.value}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    get_gender();
    Get.back();

    emit(AuthLoaded());
    }
    catch (e)
    {
    errorSnackbar("can't update categories");
    emit(AuthError());
    }
  }

  updateprofile(UpdateProfile event, Emitter<AuthState> emit) async {
    try
    {
    emit(AuthLoading());

    http.Response response =
        await http.put(Uri.parse("http://$ip:4000/api/update/$userid"),
            body: json.encode({
              'fullName': event.name,
              'country': event.cntry,
              'birthDate': event.dob.toIso8601String()
            }),
            headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    Get.back();

    emit(AuthLoaded());
    }
    catch (e)
    {
    errorSnackbar("can't update categories");
    emit(AuthError());
    }
  }

  int downloads = 0;

  createReview(CreateReview event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      http.Response response = await http.post(
          Uri.parse("http://$ip:4000/api/create/review"),
          body: json.encode(event.review),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      Map m = json.decode(response.body);
      successSnackbar(m['message']);
      Get.back();

      emit(AuthLoaded());
    } catch (e) {
      errorSnackbar("can't review ");
      emit(AuthLoaded());
    }
  }

  getreview(GetReview event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      review = [];
      http.Response response = await http
          .get(Uri.parse("http://$ip:4000/api/review/${event.id}"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      Map m = json.decode(response.body);
      review = m['reviews'];

      http.Response response12 = await http
          .get(Uri.parse("http://$ip:4000/api/download/${event.id}"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      List m1 = json.decode(response12.body);
      downloads = m1.length;
      emit(AuthLoaded());
    } catch (e) {
      emit(AuthError());
    }
  }

  getcart() async {
    emit(AuthLoading());

    http.Response response =
        await http.get(Uri.parse("http://$ip:4000/api/cart/$userid"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    List ct = json.decode(response.body);
    if (ct.isNotEmpty) {
      cart = [];
      for (int i = 0; i < ct.length; i++) {
        cart.add(ct[i]['books']);
        cart[i][0]['cartid'] = ct[i]['id'];
      }

      total_price =
          cart.fold(0, (sum, item) => sum + double.parse(item[0]['price'].toString()));
    } else {
      cart = [];
      total_price = 0.0;
    }

    emit(AuthLoaded());
  }

  putcart(PutCart event, Emitter<AuthState> emit) async {
    try
     {
    emit(AuthLoading());

    http.Response response = await http.put(
        Uri.parse("http://$ip:4000/api/cartdata/$userid"),
        body: json.encode(event.m),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    getcart();
    successSnackbar("Added to Cart");
    emit(AuthLoaded());
    }
     catch (e)
     {
       emit(AuthError());
     }
  }

   forgetPassword(ForgrtPassword event, Emitter<AuthState> emit) {
  }

   cntry(Cntry event, Emitter<AuthState> emit) async {
    try
    {
      emit(AuthLoading());
      http.Response response =
          await http.post(Uri.parse("http://$ip:4000/api/createProfile"),
          body: json.encode({
            'userId': userid,
            'fullName': username,
            'country': cn.cntry.value,
            "birthDate": null,
            "gender": cn.gender.value
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      print(response.body);
      if(response.statusCode == 200 || response.statusCode == 200)
        {
          Get.off(() => Category());
        }
      emit(AuthLoaded());
    }
    catch (e)
     {
       errorSnackbar("unable to store Country , Please try again");
       emit(AuthError());
     }
  }
}

create_db() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'data.db');

  const table = """
                CREATE TABLE Downloads (id TEXT PRIMARY KEY , data TEXT ,last TEXT);""";
  Splash.database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(table);
    },
  );

}

insert_data(String id) {
  String data = [].toString();
  String last = [].toString();
  String qry = "INSERT INTO Downloads VALUES( '$id', '$data' ,'$last')";
  Splash.database!.rawInsert(qry).then((value) {});
}
