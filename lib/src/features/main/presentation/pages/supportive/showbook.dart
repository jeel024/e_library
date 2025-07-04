import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:e_library/src/config/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:flutter/widgets.dart' as Flutter;
import 'package:path/path.dart' as path;
import 'package:e_library/src/config/firebase.dart';
import 'package:e_library/src/features/auth/presentation/pages/login.dart';
import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';
import 'package:epub_parser/epub_parser.dart';
import 'package:epub_parser/src/entities/epub_byte_content_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../main.dart';
import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/logic_bloc/logic_bloc.dart';
import '../../../../../config/contants/variable_const.dart';
import 'package:flutter/src/widgets/image.dart' as Image;
//final Map<String, EpubByteContentFile>? images; required this.images,


class Showbook extends StatefulWidget {
  List l, c;
  int i;
  Map<String, EpubByteContentFile>? images;
  String index;
  bool demo;
  Showbook(this.l, this.c, this.i, this.images, this.index,this.demo, {super.key});

  @override
  State<Showbook> createState() => _ShowbookState();
}

class _ShowbookState extends State<Showbook> {
  Mycontroll cn = Get.put(Mycontroll(), permanent: true);

  //late EpubController _epubReaderController;
  PageController controller = PageController();
  List l = [];
  List c = [];
  late ValueNotifier<int> _timerValueNotifier;
  late Timer _timer;
  int _seconds = 500;
  //EpubBook? document;
  final ScrollController _controller =  ScrollController();
  EpubBook? epubBook;

  /*String buildHtmlWithReplacedImages(
      htmlDom.Document document, List<String?> imageUrls) {
    for (htmlDom.Element imgElement in document.getElementsByTagName('img')) {
      imgElement.replaceWith(htmlDom.Element.tag('div'));
    }
    return document.outerHtml;
  }*/
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        _timerValueNotifier.value = _seconds;
      }
      else {
        timer.cancel();
        Get.back();
        Get.snackbar("Download","Download book to continue reading",backgroundColor: Colors.red,icon: const Icon(Icons.downloading),colorText: Colors.white);

      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: cn.current.value);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controller.jumpTo(cn.last.value);
    });
    l = widget.l;
    c = widget.c;

    _timerValueNotifier = ValueNotifier<int>(_seconds);

    if(!widget.demo)
      {
        startTimer();
      }

    // show();

    // _epubReaderController = EpubController(
    //     document:
    //         EpubDocument.openFile(BlocProvider.of<LogicBloc>(context).path!),
    //     epubCfi: BlocProvider.of<LogicBloc>(context).cfi);
  }
  @override
  void dispose() {
    if(!widget.demo)
      {
        _timerValueNotifier.dispose();
        _timer.cancel();
      }

    super.dispose();
  }
  show() async {
    List<int> bytes =
        await BlocProvider.of<LogicBloc>(context).path!.readAsBytes();
    epubBook = await EpubReader.readBook(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.orange,
              title: Obx(() => Text(c[cn.current.value]))),
          backgroundColor: Colors.orange.shade50,
          drawer: Drawer(
              width: 250,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.orange.shade400,
              child: SafeArea(
                  child: ListView.builder(
                itemCount: c.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                        onTap: () {
                          cn.current.value = index;
                          controller.jumpToPage(index);
                          Get.back();
                        },
                        child: ListTile(
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: Colors.orange.shade200,
                          title: Text(c[index]),
                        )),
                  );
                },
              ))),
          body:


      PageView.builder(
            controller: controller,
            onPageChanged: (value) {
              cn.current.value = value;

            },
            itemCount: l.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              String chapterHtml = l[index];

              htmlDom.Document document = htmlParser.parse(chapterHtml);

              List<String?> imageUrls =
                  document.getElementsByTagName('img').map((element) {
                return element.attributes['src'];
              }).toList();

              List chapterImages = imageUrls
                  .map((imageUrl) => widget.images![imageUrl]!)
                  .toList();

              return SingleChildScrollView(
                controller: _controller,
                physics:  (!widget.demo) ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(onTap: () => Navigator.pop(context),
                        child: (widget.demo) ? const SizedBox() :  Container(decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(10)),child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Buy a book to view fully",style: size(18.sp, Colors.white,true,)),
                        ),),
                      ),

                      (widget.demo) ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                            child: ValueListenableBuilder<int>(
                              valueListenable: _timerValueNotifier,
                              builder: (context, value, _) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    '$value seconds remaining',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Html(onLinkTap: (url, context, attributes, element) async {
                        await launch(url!);                      },
                        data: chapterHtml,
                        style: {
                          'body': Style(
                            fontSize: FontSize.medium,
                          ),
                          'img': Style(),
                        },
                      ),

                      ...chapterImages.map((image) {
                        List<int> imageData = image.Content as List<int>;
                        if (imageData.isNotEmpty) {
                          Uint8List imageDataUint8 =
                          Uint8List.fromList(imageData);
                          return Flutter.Container(
                            height: MediaQuery.of(context).size.height*0.8,
                            width: double.infinity,
                            color: Colors.orange.shade50,
                            child: PhotoView(
                              backgroundDecoration:
                              BoxDecoration(color: Colors.orange.shade50),
                              minScale: PhotoViewComputedScale.contained * 0.8,
                              imageProvider: Flutter.MemoryImage(imageDataUint8),
                              maxScale: PhotoViewComputedScale.covered * 2.0,
                              initialScale: PhotoViewComputedScale.contained,
                              enableRotation: false,
                            ),
                          );

                        } else {
                          return const SizedBox(); // Placeholder widget if image data is not available
                        }
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          )
          /* EpubView(
          builders: EpubViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            chapterDividerBuilder: (_) => const Divider(),
          ),
          controller: _epubReaderController,
        )*/
          ),
      onWillPop: () async {

        if(widget.demo)
          {
            cn.last.value = _controller.position.pixels;
            final bloc = BlocProvider.of<AuthBloc>(context);

            bloc.last[widget.i] = {
              'id': widget.index,
              'page': cn.current.value,
              'scroll': cn.last.value
            };
            update_data1(bloc.userid, bloc.last, context);
            cn.page.value = 1;
            Get.offAll(() => const HomeScreen());
          }
        else
          {
            Get.back();
          }

        //_showCurrentEpubCfi(context);

        return true;
      },
    );
  }

  Uint8List? extractImageData(dynamic imageContent) {
    if (imageContent is Uint8List) {
      return imageContent;
    } else if (imageContent is EpubByteContentFile) {
      return Uint8List.fromList(imageContent.Content!);
    }
    return null;
  }

// void _showCurrentEpubCfi(context) {
//   final cfi = _epubReaderController.generateEpubCfi();
//   BlocProvider.of<LogicBloc>(context).add(LastView(cfi!));
// }
}

update_data1(String id, List download_books, BuildContext context) {
  String data = jsonEncode(download_books);
  String qry = " UPDATE Downloads set last = '$data' where id  = '$id'  ";
  Splash.database!.rawInsert(qry).then((value) {
    print("value $value");
    get_data1(context);
  });
}

// Future<List<ContentItem>> parseContentItems(htmlDom.Document document) async {
//   List<ContentItem> contentItems = [];
//
//   List<htmlDom.Element> textElements =
//       document.querySelectorAll('p, span, div');
//   for (htmlDom.Element textElement in textElements) {
//     String textContent = textElement.text;
//     contentItems.add(TextContentItem(textContent));
//   }
//
//   // Parse image content items and add them to the list
//   List<htmlDom.Element> imageElements = document.querySelectorAll('img');
//   for (htmlDom.Element imageElement in imageElements) {
//     List<String?> imageUrls =
//         document.getElementsByTagName('img').map((element) {
//       return element.attributes['src'];
//     }).toList();
//     Map<String, EpubByteContentFile>? images;
//     //   List<int> bytes = await BlocProvider.of<LogicBloc>(context).path!.readAsBytes();
//     //EpubBook epubBook = await EpubReader.readBook(bytes);
//     // EpubContent? bookContent = epubBook.Content;
//     // images = bookContent!.Images;
//
// // Retrieve the images for this chapter
// //     List chapterImages = imageUrls
// //         .map((imageUrl) => widget.images![imageUrl]!)
// //         .toList();
//
//     String? imageUrl = imageElement.attributes['src'];
//     if (imageUrl != null) {
//       contentItems.add(ImageContentItem(imageUrl));
//     }
//   }
//   return contentItems;
// }
//
// class ImageContentItem extends ContentItem {
//   ImageContentItem(String imageUrl) : super(imageUrl: imageUrl, text: '');
//
//   @override
//   String toString() {
//     return 'ImageContentItem';
//   }
// }
//
// class TextContentItem extends ContentItem {
//   TextContentItem(String text) : super(imageUrl: null, text: text);
//
//   @override
//   String toString() {
//     return 'TextContentItem: $text';
//   }
// }
//
// class ContentItem {
//   final String? imageUrl;
//   final String? text;
//
//   ContentItem({this.imageUrl, this.text});
// }
//
// //   customRenders: {
// //   tagMatcher('img'):
// //   CustomRender.widget(widget: (context, buildChildren) {
// //     final url = context.tree.element!.attributes['src']!
// //         .replaceAll('../', '');
// //     return Image(
// //       image: MemoryImage(
// //             Uint8List.fromList(
// //           document.Content!.Images![url]!.Content!,
// //         ),
// //       ),
// //     );
// //   }),
// // },
//
// //
// // customRenders: {
// // tagMatcher('img'):
// // CustomRender.widget(widget: (context, buildChildren) {
// // final url = context.tree.element!.attributes['src']!
// //     .replaceAll('../', '');
// // return Text("");
// // //print(document!.Content!.Images![url]!.Content!);
// // //return Image.Image(image: MemoryImage(Uint8List.fromList(document!.Content!.Images![url]!.Content!)));
// // })
// // },
//
// /*
//
// PageView.builder(
// controller: controller,
// onPageChanged: (value) {
// cn.current.value = value;
// print(cn.current.value);
// },
// itemCount: l.length,
// physics: const BouncingScrollPhysics(),
// itemBuilder: (BuildContext context, int index) {
// EpubChapter chapter = epubBook!.Chapters![index];
// String chapterHtml = l[index];
// String chapterTitle = c[index];
//
// // Parse HTML content
// htmlDom.Document document = htmlParser.parse(chapterHtml);
//
// // Extract image URLs
// List<String?> imageUrls =
// document.getElementsByTagName('img').map((element) {
// return element.attributes['src'];
// }).toList();
//
// // Retrieve the images for this chapter
// List chapterImages = imageUrls
//     .map((imageUrl) => widget.images![imageUrl]!)
//     .toList();
//
// return SingleChildScrollView(
// controller: _controller,
// physics: const BouncingScrollPhysics(),
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// chapterTitle,
// style: TextStyle(
// fontSize: 20, fontWeight: FontWeight.bold),
// ),
// SizedBox(height: 10),
// ...chapterImages.map((image) {
// List<int> imageData = image.Content as List<int>;
// if (imageData.isNotEmpty) {
// Uint8List imageDataUint8 =
// Uint8List.fromList(imageData);
// return Flutter.Image(
// image: Flutter.MemoryImage(imageDataUint8),
// );
// } else {
// return SizedBox(); // Placeholder widget if image data is not available
// }
// }).toList(),
// Html(
// data: chapterHtml,
// // Optional: Add custom style options if needed
// style: {
// 'body': Style(
// fontSize: FontSize.medium,
// ),
// 'img': Style(),
// },
// ),
// ],
// ),
// ),
// );
// },
// )*/
//
// /*
// PageView.builder(
// controller: controller,
// onPageChanged: (value) {
// cn.current.value = value;
// print(cn.current.value);
// },
// itemCount: l.length,
// physics: const BouncingScrollPhysics(),
// itemBuilder: (BuildContext context, int index) {
// EpubChapter chapter = epubBook!.Chapters![index];
// String chapterHtml = l[index];
// String chapterTitle = c[index];
// EpubContent? bookContent = epubBook!.Content;
// Map<String, EpubByteContentFile>? images = bookContent?.Images;
// // Parse HTML content
// htmlDom.Document document = htmlParser.parse(chapterHtml);
//
// // Retrieve the images for this chapter
// List<EpubByteContentFile> chapterImages = [];
// List<htmlDom.Element> imgElements = document.getElementsByTagName('img');
// for (htmlDom.Element imgElement in imgElements) {
// String? imageUrl = imgElement.attributes['src'];
//
// if (imageUrl != null && images!.containsKey(imageUrl)) {
// EpubByteContentFile image = images![imageUrl]!;
// chapterImages.add(image);
// imgElement.replaceWith(htmlDom.Element.tag('img'));
// }
// }
//
// return SingleChildScrollView(
// controller: _controller,
// physics: const BouncingScrollPhysics(),
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// chapterTitle,
// style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// ),
// SizedBox(height: 10),
// ...chapterImages.asMap().entries.map((entry) {
// int index = entry.key;
// EpubByteContentFile image = entry.value;
// List<int> imageData = image.Content as List<int>;
// Uint8List imageDataUint8 = Uint8List.fromList(imageData);
// return Column(
// children: [
// Flutter.Image.memory(
// imageDataUint8,
// width: double.infinity,
// height: 600,
// fit: BoxFit.fill,
// ),
// Html(
// data: imgElements[index].outerHtml,
// style: {
// 'body': Style(
// fontSize: FontSize.medium,
// ),
// 'img': Style(),
// },
// ),
// ],
// );
// }).toList(),
// Html(
// data: document.outerHtml,
// style: {
// 'body': Style(
// fontSize: FontSize.medium,
// ),
// 'img': Style(),
// },
// ),
// ],
// ),
// ),
// );
// },
// )*/


// return Flutter.InteractiveViewer( // Optional: Add margin around the image
//   minScale: 0.1, // Optional: Minimum scale allowed for zooming out
//   maxScale: 4.0,
//
//   child: Flutter.Image(
//     image: Flutter.MemoryImage(imageDataUint8),
//   ),
// );