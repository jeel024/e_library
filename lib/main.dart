import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_library/src/bloc/auth/auth_bloc.dart';
import 'package:e_library/src/bloc/auth/auth_event.dart';
import 'package:e_library/src/bloc/logic_bloc/logic_bloc.dart';
import 'package:e_library/src/config/contants/variable_const.dart';
import 'package:e_library/src/config/firebase.dart';
import 'package:e_library/src/features/get_started/welcome.dart';
import 'package:e_library/src/features/main/presentation/pages/bookshelf/bookshelf.dart';
import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart';

import 'src/config/theme.dart';
import 'src/features/get_started/language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
 await Hive.openBox('data');

  create_db();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<LogicBloc>(
      create: (context) => LogicBloc(),
    ),
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
    )
  ], child: const Start()));
}

class Start extends StatelessWidget  with PortraitModeMixin{
  const Start({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScreenUtilInit(
       // designSize: const Size(360, 690),
        builder: (context, child) {
          return  const GetMaterialApp(debugShowCheckedModeBanner: false,
            home: Splash(),
          );
        });
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  static Database? database;
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //secureScreen();
    Box box = Hive.box("data");
    bool login = box.get('login') ?? false;
    BlocProvider.of<AuthBloc>(context).userid = box.get('userId') ?? "";
    BlocProvider.of<AuthBloc>(context).token = box.get('userToken') ?? "";
    BlocProvider.of<AuthBloc>(context).downloadURL = box.get('image') ?? "";
    print(BlocProvider.of<AuthBloc>(context).userid);
    print(BlocProvider.of<AuthBloc>(context).token);

    Future.delayed(const Duration(seconds: 2)).then(
      (value) async {

        if (login) {
          // await get_data(context);
          get_data1(context);
          final connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {


            /*BlocProvider.of<AuthBloc>(context).add(Bookdata());*/
            Get.off(() => const HomeScreen());

          }
          else
            {
              Mycontroll cn = Get.put(Mycontroll(),permanent: true);
              // cn.page.value = 1;
              Get.off(() => const BookShelf());
            }
        } else {
          Get.off(() => const Welcome());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.jpeg'),
            Text(
              "E-Books",
              style: size(30.sp, Colors.white, true),
            )
          ],
        ),
      ),
    );
  }
}


mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return Container();
  }
}

mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return Container();
  }

  @override
  void dispose() {
    _enableRotation();
    super.dispose();
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}