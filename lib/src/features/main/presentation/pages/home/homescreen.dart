import 'package:e_library/src/config/contants/variable_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../bloc/auth/auth_state.dart';
import '../bag/add_to_bag.dart';
import '../bookshelf/bookshelf.dart';
import 'first.dart';
import '../profile/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(Bookdata());
  }


  //int btBar = 0;

  void _onItemTapped(int index) {
    setState(() {
      cn.page.value = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    first(),
    BookShelf(),
    AddToBag(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    //get_data1(context);
    return WillPopScope(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: cn.page.value ,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black.withOpacity(0.4),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookshell"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: "My bag"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
        ),
        body: BlocBuilder<AuthBloc,AuthState>(builder: (context, state) {
          if(state is AuthLoading)
            {
              return Center(child: CircularProgressIndicator(),);
            }
          else
            {
              return _pages.elementAt(cn.page.value );
            }

        },) ,
      ),
      onWillPop: () async {
        Get.defaultDialog(
            middleText: "Do You Want to Exit ?",
            confirmTextColor: Colors.orange,
            cancel: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel",style: TextStyle(fontSize: 17,color: Colors.orange),)),
            title: "Exit App !!",
            confirm: TextButton(onPressed: () {
              Future<void> pop({bool? animated}) async {
                await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
              }
              pop();
            }, child: const Text("Yes",style: TextStyle(fontSize: 17,color: Colors.orange))));
        return true;
      },
    );
  }
}
