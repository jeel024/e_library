import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/theme.dart';
import 'downloads.dart';
import 'reading.dart';

class BookShelf extends StatefulWidget {
  const BookShelf({Key? key}) : super(key: key);

  @override
  State<BookShelf> createState() => _BookShelfState();
}

class _BookShelfState extends State<BookShelf> with TickerProviderStateMixin {
  Mycontroll cn = Get.put(Mycontroll(), permanent: true);
  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    tabController = TabController(initialIndex: cn.tab.value, length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
          bottom: TabBar(
              labelStyle: size(15.sp, Colors.orange, false),
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              unselectedLabelStyle:
                  size(15.sp, Colors.orange.withOpacity(0.5), false),
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              onTap: (value) {
                cn.tab.value = value;
                setState(() {});
              },
              controller: tabController,
              tabs: const [
                Tab(
                  child: Text("All Books"),
                ),
                Tab(
                  child: Text("Downloads"),
                )
              ]),
          elevation: 0,
          titleTextStyle: size(20.sp, Colors.orange, true),
          backgroundColor: Colors.grey[50],
          title: const Text("My Bookshelf"),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [Reading(), Downloads()],
      ),
    );
  }
}
