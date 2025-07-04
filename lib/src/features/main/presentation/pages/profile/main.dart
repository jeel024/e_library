
import 'package:e_library/src/features/main/presentation/pages/profile/update_category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../bloc/auth/auth_bloc.dart';
import '../../../../../bloc/auth/auth_event.dart';
import '../../../../../bloc/auth/auth_state.dart';
import '../../../../../config/contants/variable_const.dart';
import '../../../../../config/theme.dart';

import 'history.dart';
import 'logout.dart';
import 'personal_info.dart';
import 'saved.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Mycontroll cn = Get.put(Mycontroll(),permanent: true);
  bool temp = false;
  List profile = [
    "Personal information",
    "Book History",
    "Category",
    "Save for Later",
    "Logout"
  ];
  List icon = [
    Icons.person,
    Icons.menu_book,
    Icons.category,
    Icons.favorite,
    Icons.logout
  ];
  final ImagePicker picker = ImagePicker();
  XFile? image;
  var status;
  var status1;

  get_per() async {
    status1 = await Permission.camera.status;
    if (status1 == PermissionStatus.denied) {
      //Map<Permission, PermissionStatus> statuses =
      await Permission.camera.request();
    }
  }

  Map data = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_per();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile",
          style: size(20.sp, Colors.white, true),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity.w,
            height: 200.h,
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return (BlocProvider.of<AuthBloc>(context).downloadURL != '')
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    BlocProvider.of<AuthBloc>(context).downloadURL,),
                                radius: 60.r,
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(
                                    'images/${BlocProvider.of<AuthBloc>(context).genderModel!.gender.toString()}.png'),
                                backgroundColor: Colors.orange.shade50,
                                radius: 60.r,
                              );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 200.h,
                              decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    "Choose Image ",
                                    style: size(17.sp, Colors.black, true),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  BlocBuilder<AuthBloc,AuthState>(builder: (context, state) {
                                    if(state is AuthLoading)
                                      {
                                        return Center(child: CircularProgressIndicator(),);
                                      }
                                    else
                                      {
                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (status1 ==
                                                    PermissionStatus.denied) {
                                                  get_per();
                                                } else {

                                                  image = await picker.pickImage(
                                                      source: ImageSource.camera);

                                                  BlocProvider.of<AuthBloc>(context).add(StoreImage(image));


                                                  // final FirebaseStorage storage =
                                                  //     FirebaseStorage.instance;
                                                  //
                                                  // successSnackbar(
                                                  //     "It may take few seconds...");
                                                  // var downloadURL = '';
                                                  // if (image != null) {
                                                  //   final ref = storage.ref().child(
                                                  //       'images/${DateTime.now().toString()}');
                                                  //
                                                  //   final uploadTask = ref.putData(
                                                  //       await image!
                                                  //           .readAsBytes()); //ref.putXFile(image);
                                                  //   final snapshot = await uploadTask
                                                  //       .whenComplete(() {});
                                                  //   downloadURL = await snapshot.ref
                                                  //       .getDownloadURL();
                                                  //   BlocProvider.of<LogicBloc>(
                                                  //           context)
                                                  //       .add(TakeImage(downloadURL));
                                                  // }
                                                  //
                                                  // // Save download URLs to Firestore
                                                  // final CollectionReference users =
                                                  //     FirebaseFirestore.instance
                                                  //         .collection('users');
                                                  // final firebaseAuth =
                                                  //     FirebaseAuth.instance;
                                                  // final firebaseUser =
                                                  //     firebaseAuth.currentUser;
                                                  // final userId = firebaseUser!.uid;
                                                  // final DocumentReference user =
                                                  //     users.doc(userId);
                                                  // await user
                                                  //     .update({'image': downloadURL});
                                                  //
                                                  // Get.back();
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.orange.shade100,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                    width: 50.w,
                                                    height: 50.h,
                                                    child: const Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.orange,
                                                      size: 40,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  Text(
                                                    "Camera",
                                                    style: size(
                                                        20.sp, Colors.black, false),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (status1 ==
                                                    PermissionStatus.denied) {
                                                  get_per();
                                                  Get.back();
                                                } else {
                                                  image = await picker.pickImage(
                                                      source: ImageSource.gallery);

                                                  BlocProvider.of<AuthBloc>(context).add(StoreImage(image));
/*
                                                  final FirebaseStorage storage =
                                                      FirebaseStorage.instance;
                                                  successSnackbar(
                                                      "It may take few seconds to change image...");
                                                  var downloadURL = '';

                                                  if (image != null) {
                                                    final ref = storage.ref().child(
                                                        'images/${DateTime.now().toString()}');

                                                    final uploadTask = ref.putData(
                                                        await image!
                                                            .readAsBytes()); //ref.putXFile(image);
                                                    final snapshot = await uploadTask
                                                        .whenComplete(() {});
                                                    downloadURL = await snapshot.ref
                                                        .getDownloadURL();
                                                  }

                                                  // Save download URLs to Firestore
                                                  final CollectionReference users =
                                                  FirebaseFirestore.instance
                                                      .collection('users');
                                                  final firebaseAuth =
                                                      FirebaseAuth.instance;
                                                  final firebaseUser =
                                                      firebaseAuth.currentUser;
                                                  final userId = firebaseUser!.uid;
                                                  final DocumentReference user =
                                                  users.doc(userId);
                                                  await user
                                                      .update({'image': downloadURL});
                                                  BlocProvider.of<LogicBloc>(context)
                                                      .add(TakeImage(downloadURL));

                                                  Get.back();*/
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.orange.shade100,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                    width: 50,
                                                    height: 50,
                                                    child: const Icon(
                                                      Icons
                                                          .photo_camera_back_outlined,
                                                      color: Colors.orange,
                                                      size: 40,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  Text(
                                                    "Gallery",
                                                    style: size(
                                                        20.sp, Colors.black, false),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                  },)
                                  ,
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                          height: 35.h,
                          width: 35.h,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.orange, width: 2),
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(40)),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.orange,
                          )),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Get.to(() => const Personal_Info());
                    },
                    child: (BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {

                        return Text(
                           BlocProvider.of<AuthBloc>(context).getProfile!.fullName.toString(),
                          style: size(18.sp, Colors.white, false),
                        );
                      },
                    ))),
                Text(
                  BlocProvider.of<AuthBloc>(context).genderModel!.gender.toString(),
                  style: size(18.sp, Colors.white, false),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity.w,
            height: 348.h,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => const Personal_Info());
                            break;
                          case 1:
                            Get.to(() => const History());
                            break;
                          case 2:
                            Get.to(() => const UpdateCategory1());
                            break;
                          case 3:
                            Get.to(() => const Save());
                            break;
                          case 4:
                            logout(context);
                            break;
                        }
                      },
                      title: Text(profile[index]),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.deepOrangeAccent,
                      ),
                      leading: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
                        width: 30,
                        height: 30,
                        child: Icon(
                          icon[index],
                          color: Colors.orange,
                          size: 20,
                        ),
                      ));
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.2),
                  );
                },
                itemCount: profile.length),
          )
        ],
      ),
    );
  }
}
