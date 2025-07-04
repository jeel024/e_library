import 'package:e_library/src/config/contants/snackbar.dart';
import 'package:e_library/src/config/theme.dart';
import 'package:epub_parser/epub_parser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/logic_bloc/logic_bloc.dart';
import '../../../../../config/contants/variable_const.dart';
import 'showbook.dart';

class OpenBook extends StatefulWidget {
  String index,link;
  bool temp;

  OpenBook(this.index, this.temp,this.link);

  @override
  State<OpenBook> createState() => _OpenBookState();
}

class _OpenBookState extends State<OpenBook> {
  List l = [];
  List c = [];
  Map<String, EpubByteContentFile>? images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_startTimer();
    get();
  }

  Mycontroll cn = Get.put(Mycontroll(), permanent: true);

  get() async {
    // String fileName = 'sample.epub';
    // String fullPath = path.join(io.Directory.current.path, fileName);
    // var targetFile = new io.File(fullPath);
    // List<int> bytes = await targetFile.readAsBytes();

    if (!widget.temp)
    {
      final response = await http.get(Uri.parse(widget.link.toString().replaceAll('localhost', '$ip')));

      if (response.statusCode == 200)
      {
        print("object");
        cn.current.value = 0;
        cn.last.value = 0.0;
        EpubBook epubBook = await EpubReader.readBook(response.bodyBytes);

        epubBook.Chapters!.forEach((EpubChapter chapter) {
          l.add(chapter.HtmlContent);
          c.add(chapter.Title);
        });
        EpubContent? bookContent = epubBook.Content;
        images = bookContent!.Images;
        Get.off(() => Showbook(l, c, 0, images, widget.index,false));
      } else {
        errorSnackbar('Failed to load epub');
      }
    }
    else
    {
      List<int> bytes =
          await BlocProvider.of<LogicBloc>(context).path!.readAsBytes();
      EpubBook epubBook = await EpubReader.readBook(bytes);

      epubBook.Chapters!.forEach((EpubChapter chapter) {
        l.add(chapter.HtmlContent);
        c.add(chapter.Title);
      });
      EpubContent? bookContent = epubBook.Content;
      images = bookContent!.Images;
      for (int i = 0; i < BlocProvider.of<AuthBloc>(context).last.length; i++) {
        if (widget.index == BlocProvider.of<AuthBloc>(context).last[i]['id']) {
          Get.off(() => Showbook(l, c, i, images, widget.index,true));
          break;
        }
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.orange,),
              const SizedBox(height: 10,),
              Text("Opening....",style: size(15.sp, Colors.orange,false),),
            ],
          ),
        ));
  }
}
// Column(
// children: images!.values.map((image) {
// List<int>? imageData = image.Content as List<int>?;
// if (imageData != null) {
// Uint8List uint8ImageData = Uint8List.fromList(imageData);
// return Flutter.Image(
// image: Flutter.MemoryImage(uint8ImageData),
// width: double.infinity, // Adjust the width as needed
// height: 600, fit: BoxFit.fill,// Adjust the height as needed
// );
// } else {
// return SizedBox(); // Placeholder widget if image data is not available
// }
// }).toList().cast<Widget>(),
// ),
