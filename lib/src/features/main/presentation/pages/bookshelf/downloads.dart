import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../bloc/auth/auth_state.dart';
import '../../../../../config/contants/snackbar.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/firebase.dart';
import '../../../../../config/theme.dart';
import '../../../../auth/presentation/pages/login.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  Mycontroll cn = Get.put(Mycontroll(), permanent: true);

  //List download_data = [];
  final DownloadController controller1 = Get.put(DownloadController());
  List book = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = BlocProvider.of<AuthBloc>(context).purchased;
    controller1.downloading.value = List.filled(book.length, 0.0);
    get_per();
    print(BlocProvider.of<AuthBloc>(context).purchased.length);
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(Login.instanc.currentUser!.uid)
    //     .update({'history': []});
  }

  var status1;

  get_per() async {
    status1 = await Permission.manageExternalStorage.status;
    if (status1 == PermissionStatus.denied) {
      //Map<Permission, PermissionStatus> statuses =
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        book = BlocProvider.of<AuthBloc>(context).purchased;
        return (book.isEmpty)
            ? Center(
                child: Column(
                  children: [
                    Lottie.asset('images/search.json',
                        height: 250.sp, reverse: true),
                    Text("Nothing to Download",
                        style: size(20.sp, Colors.orange, true)),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: book.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                      book[index]['image'].toString().replaceAll('localhost', '$ip'))
                                  // image: FileImage(File(book[index]['image']))
                                  ),
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
                          width: 240.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      book[index]['name'],
                                      style: size(18.sp, Colors.black, true),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        controller1.downloadFile(
                                            book[index], context, index);
                                      },
                                      icon: const Icon(Icons.downloading)),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
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
                                    book[index]['author'],
                                    style: size(16.sp, Colors.orange, false),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Obx(() => (controller1.downloading[index]
                                              .toDouble() >
                                          0.1 &&
                                      controller1.downloading[index]
                                              .toDouble() <
                                          100)
                                  ? Text("${controller1.downloading[index]}%")
                                  : const SizedBox()),
                              Obx(
                                () => (controller1.downloading[index]
                                                .toDouble() >
                                            0.1 &&
                                        controller1.downloading[index]
                                                .toDouble() <
                                            100)
                                    ? Container(
                                        height:
                                            8.0, // Adjust the height to your preference
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          child: LinearProgressIndicator(
                                            value: controller1
                                                    .downloading[index]
                                                    .toDouble() /
                                                100,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.orange),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Obx(() => (controller1.downloading[index]
                                          .toDouble() ==
                                      100)
                                  ? Text(
                                      "Storing...",
                                      style: size(15.sp, Colors.orange, false),
                                    )
                                  : const SizedBox())
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}

class DownloadController extends GetxController {

  Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  RxList downloading = [].obs;

  Future<void> downloadFile(
      Map<String, dynamic> data, BuildContext context, int i) async {
    String filePath1 = '';

    //try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(data['book'].toString().replaceAll('localhost', '$ip')));
      final streamedResponse = await client.send(request);

      final contentLength = streamedResponse.contentLength;
      int receivedBytes = 0;

      final fileStream = streamedResponse.stream;
      final directory = await getTemporaryDirectory();
      filePath1 = '${directory.path}/epub${Random().nextInt(1000)}.epub';
      final file = File(filePath1);

      final bytes = await fileStream.fold<List<int>>(<int>[],
          (previous, List<int> chunk) {
        receivedBytes += chunk.length;
        final progressPercentage = (receivedBytes / contentLength!) * 100;
        downloading[i] = progressPercentage.toPrecision(0);

        return previous..addAll(chunk);
      });

      await file.writeAsBytes(bytes);

      String filePath = '';
      try {
        final response = await http.get(Uri.parse(data['image'].toString().replaceAll('localhost', '$ip')));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          filePath = '${directory.path}/image${Random().nextInt(1000)}.jpg';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
        } else {
        }
      } catch (e) {
      }

      //get_data1(context);

      final bloc = BlocProvider.of<AuthBloc>(context);

      final seen = {'id': data['id'], 'page': 0, 'scroll': 0.0};
      bloc.last.add(seen);

      bloc.download_books.add({
        'id': data['id'],
        'name': data['name'],
        'image': filePath,
        'by': data['author'],
        'path': filePath1,
      });

    http.Response response = await http.post(
      //192.168.255.252
        Uri.parse("http://$ip:4000/api/create/download"),
        body: json.encode({'bookId': data['id'],'userId': bloc.userid}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${bloc.token}'
        });
    print(response.body);
    print("8888888888888888888888888888888888");

       update_data("", bloc.download_books,bloc.last, context);
      bloc.purchased.remove(data);
      //store_data(context);

        bloc.add(Purchased(data));
        cn.tab.value = 0 ;
     Get.offAll(() => const HomeScreen());


    // } catch (e) {
    //   errorSnackbar('Error downloading EPUB file: $e');
    // }
  }
}
/*
class DownloadController extends GetxController {
  final _progress = 0.0.obs;
  double get progress => _progress.value;

  void downloadFile(String url) async {
    final request = http.MultipartRequest('GET', Uri.parse(url));
    final response = await request.send();

    final totalBytes = response.contentLength ?? 0;
    var receivedBytes = 0;

    final appDocDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocDir.path}/downloaded_file');
    print(file.toString());

    response.stream.listen((chunk) {
      receivedBytes += chunk.length;
      final progressPercentage = (receivedBytes / totalBytes) * 100;
      _progress.value = progressPercentage;
    }).onDone(() {
      print("done");
      // Handle the downloaded file here
    });
  }
}*/
// try {
// final response = await http.get(Uri.parse(data['image']));
// if (response.statusCode == 200) {
// final directory = await getTemporaryDirectory();
// filePath = '${directory.path}/image${Random().nextInt(1000)}.jpg';
// final file = File(filePath);
// await file.writeAsBytes(response.bodyBytes);
// } else {
// print('Failed to save image. Response status: ${response.statusCode}');
// }
// } catch (e) {
// print('An error occurred: $e');
// }

// void _startTimer() {
//   Timer.periodic(const Duration(milliseconds: 1000), (timer) {
//     setState(() {
//       _progressValue += 0.2;
//     });
//     if (_progressValue >= 1.0) {
//       timer.cancel();
//       BlocProvider.of<LogicBloc>(context).add(Downloading(false, true));
//     }
//   });
// }
/*SizedBox(height: 4.h),
                    (!BlocProvider.of<LogicBloc>(context).d_val)
                        ? Text("${(_progressValue * 100).toStringAsFixed(2)} %")
                        : const Text(""),
                    SizedBox(height: 4.h),
                    (!BlocProvider.of<LogicBloc>(context).d_val)
                        ? Container(
                            height: 5.h,
                            width: 200.w,
                            child: LinearProgressIndicator(
                              value: _progressValue,
                              backgroundColor: Colors.orange[100],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.orange),
                            ),
                          )
                        : const Text(""),*/
// return (!BlocProvider.of<LogicBloc>(context)
//         .d_val)
//     ? IconButton(
//         onPressed: () async {
//           /*downloadAndSaveEpub(context,data,
//                   'https://filesamples.com/samples/ebook/epub/Alices%20Adventures%20in%20Wonderland.epub')
//               .then(
//             (value) {
//               BlocProvider.of<LogicBloc>(context)
//                   .add(Downloading(true, false));
//             },
//           );*/
//         },
//         icon: const Icon(Icons.downloading))
//     :

// downloadAndSaveEpub(context,book[index],
//         'https://filesamples.com/samples/ebook/epub/Alices%20Adventures%20in%20Wonderland.epub',0)
//     .then(
//   (value) {
//     BlocProvider.of<LogicBloc>(context)
//         .add(Downloading(true, false));
//   },
// );
/*for(int i=0;i<download_data.length;i++)
      {
        for(int j=0;j<data.length;j++)
          {
            print(data[j]['id']);
            print(download_data[i]["id"]);
            if(data[j]['id'] == download_data[i]["id"])
            {
              book.add(data[j]);
              continue;
            }
          }
      }*/
// await fileStream.listen(
//       (chunk) {
//     receivedBytes += chunk.length;
//     final progressPercentage = (receivedBytes / contentLength!) * 100;
//     _progress.value = progressPercentage;
//     downloading[i] = progressPercentage.toPrecision(0);
//     print("Download progress: ${_progress.value}%");
//
//
//   },
// ).asFuture();
/*Expanded(
                          child: BlocBuilder<LogicBloc, LogicState>(
                            builder: (context, state) {
                              if (state is LogicLoading) {
                                return const CircularProgressIndicator();
                              }

                              return TextButton(
                                onPressed: () {
                                  final bloc =BlocProvider.of<AuthBloc>(context);

                                  File f = File(book[index]['path']);
                                  BlocProvider.of<LogicBloc>(context).path = f;

                                  cn.current.value = bloc.last[index]['page'];
                                  cn.last.value =bloc.last[index]['scroll'];

                                  Get.to(() => OpenBook(bloc.last[index]['id']));
                                },
                                child: Text(
                                  "View Book",
                                  style: size(14.sp, Colors.orange, false),
                                ),
                              );
                            },
                          ),
                        ),*/