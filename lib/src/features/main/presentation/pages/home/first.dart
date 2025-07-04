import 'package:e_library/src/features/main/presentation/pages/home/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../config/theme.dart';
import 'category_book.dart';
import 'search.dart';

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> with TickerProviderStateMixin {
  TabController? tabController;
  int a = 0, btBar = 0;
  List all_item = ["All"];
  List<Tab> tabs = [];
  List<Container> container = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get_data(context);
    //book_data(context);
    BlocProvider.of<AuthBloc>(context).topic = [];
    all_item.addAll(BlocProvider.of<AuthBloc>(context).genderModel!.category as Iterable);
    for (int i = 0; i < all_item.length; i++) {
      tabs.add(Tab(
        child: Text(all_item[i].toString()),
      ));
    }
    container.add(con(context));
    for (int i = 0; i < BlocProvider.of<AuthBloc>(context).genderModel!.category!.length ; i++) {
      String curr_cat = BlocProvider.of<AuthBloc>(context).genderModel!.category![i].toString();
      container.add(cat(context,curr_cat));
    }
  }

  @override
  Widget build(BuildContext context) {
    tabController =
        TabController(initialIndex: a, length: tabs.length, vsync: this);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          unselectedLabelStyle:
              size(15.sp, Colors.orange.withOpacity(0.5), false),
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          onTap: (value) {
            a = value;
            setState(() {});
          },
          controller: tabController,
          tabs: tabs,
        ),
        title: Text(
          "Discover",
          style: size(30.sp, Colors.orange, true),
        ),
        backgroundColor: Colors.grey[50],
        actions: [
          InkWell(onTap: () {
            Get.to(() => const Search());
          },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
              width: 25,
              child: const Icon(
                Icons.search,
                color: Colors.orange,
                size: 20,
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      body: TabBarView(
        controller: tabController,
        children: container,
      ),
    );
  }
}