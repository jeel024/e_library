import 'dart:convert';

import 'package:e_library/src/config/contants/snackbar.dart';
import 'package:e_library/src/features/main/presentation/pages/home/homescreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/auth/auth_bloc.dart';
import '../../../../bloc/auth/auth_event.dart';
import '../../../../bloc/auth/auth_state.dart';
import '../../../../config/contants/button.dart';
import '../../../../config/contants/textfield.dart';
import '../../../../config/theme.dart';

import 'forget_password.dart';
import 'signin.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static FirebaseAuth instanc = FirebaseAuth.instance;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SafeArea(
          child: (BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Center(
                        child: Text(
                      "Please wait ",
                      style: TextStyle(color: Colors.orange),
                    ))
                  ],
                );
              }
              return widget1(context);
            },
          )),
        ),
      ),
    );
  }
}

widget1(BuildContext context) {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: size(25.sp, Colors.black, true),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          "Email Address",
          style: size(20.sp, Colors.black, false),
        ),
        SizedBox(
          height: 10.h,
        ),
        email_textfield(email, "Enter Email here"),
        SizedBox(
          height: 15.h,
        ),
        Text(
          "Password",
          style: size(20.sp, Colors.black, false),
        ),
        SizedBox(
          height: 10.h,
        ),
        pass_textfield(pass, "Enter Password"),
        SizedBox(
          height: 30.h,
        ),
        InkWell(
          onTap: () {

            //email_pass_login(email.text, pass.text);
            if(email.text.isEmpty  )
              {
                errorSnackbar("please enter email");
              }
            else if(pass.text.isEmpty)
              {
                errorSnackbar("Please enter password");
              }
            else
              {
                BlocProvider.of<AuthBloc>(context)
                    .add(Email_Login(email.text, pass.text));
              }

          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.orange,
                ));
              }
              return button("Login");
            },
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Center(
          child: TextButton(
              onPressed: () {
                get_email(context, email.text);
              },
              child: Text("Forget password ? ",
                  style: size(16.sp, Colors.orange, false))),
        ),
        SizedBox(
          height: 5.h,
        ),
        // Stack(children: [
        //   const Divider(),
        //   Center(
        //       child: Container(
        //           color: Colors.grey[50],
        //           child: Text(
        //             "Or Continue with",
        //             style: TextStyle(color: Colors.black.withOpacity(0.2)),
        //           )))
        // ]),
        // SizedBox(
        //   height: 20.h,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //
        //     OutlinedButton(
        //         style: OutlinedButton.styleFrom(shape: const CircleBorder()),
        //         onPressed: () async {
        //           BlocProvider.of<AuthBloc>(context).add(Google_Signin());
        //           },
        //         child: Image.asset(
        //           'images/google.png',
        //           height: 20.h,
        //         )),
        //     OutlinedButton(
        //         style: OutlinedButton.styleFrom(shape: const CircleBorder()),
        //         onPressed: () async {
        //
        //           /*Future<UserCredential> signInWithFacebook() async {
        //             // Trigger the sign-in flow
        //             final LoginResult result = await FacebookAuth.instance.login();
        //
        //             // Create a credential from the access token
        //             final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        //             //FacebookAuthProvider.credential(result.accessToken!.token);
        //
        //             // Sign in with the credential
        //             return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        //           }
        //           try {
        //             final UserCredential userCredential = await signInWithFacebook();
        //             print('User logged in: ${userCredential.user}');
        //           } on FirebaseAuthException catch (e) {
        //             if (e.code == 'account-exists-with-different-credential') {
        //               print(e.toString());
        //             } else if (e.code == 'invalid-credential') {
        //               print(e.toString());
        //             }
        //           } catch (e) {
        //             print(e.toString());
        //           }*/
        //           /*//Future signInFacebook() async {
        //
        //             try {
        //               final facebookLogin = FacebookLogin();
        //
        //               // bool isLoggedIn = await facebookLogin.isLoggedIn;
        //
        //               final FacebookLoginResult result =
        //                   await facebookLogin.logIn(
        //                 permissions: [
        //                   FacebookPermission.publicProfile,
        //                   FacebookPermission.email,
        //                 ],
        //               );
        //
        //               switch (result.status) {
        //                 case FacebookLoginStatus.success:
        //                   String token = result.accessToken!.token;
        //
        //                   final AuthCredential credential =
        //                       FacebookAuthProvider.credential( token);
        //                   //FacebookAuthProvider.getCredential(accessToken: token);
        //
        //                   await FirebaseAuth.instance
        //                       .signInWithCredential(credential);
        //
        //                   break;
        //                 case FacebookLoginStatus.cancel:
        //                   break;
        //                 case FacebookLoginStatus.error:
        //                   print(result.error);
        //                   break;
        //               }
        //
        //               //return true;
        //             } catch (error) {
        //               errorSnackbar('error');
        //              // return false;
        //             }
        //           //}
        //           final faceebooklogin = await FacebookAuth.instance.login();
        //           //await faceebooklogin.signInFacebook();
        //           // final faceebooklogin = await FacebookAuth.instance.login();
        //           // final userdata = await FacebookAuth.instance.getUserData();
        //           // final facebookAuthcredential = FacebookAuthProvider.credential(faceebooklogin.accessToken!.token);
        //           // await FirebaseAuth.instance.signInWithCredential(facebookAuthcredential);
        //           // print(userdata);*/
        //           //final faceebooklogin = await FacebookAuth.instance.login();
        //          // await faceebooklogin.signInFacebook();
        //          //  final faceebooklogin = await FacebookAuth.instance.login();
        //          //  final userdata = await FacebookAuth.instance.getUserData();
        //          //  final facebookAuthcredential = FacebookAuthProvider.credential(faceebooklogin.accessToken!.token);
        //          //  await FirebaseAuth.instance.signInWithCredential(facebookAuthcredential);
        //
        //          // UserCredential userCredential = await Login.instanc.signInWithCredential(credential);
        //          //  final fb = FacebookLogin();
        //          //  print("object");
        //          //  final res = await fb.logIn(permissions: [
        //          //  FacebookPermission.publicProfile,
        //          //  FacebookPermission.email,
        //          //  ]);
        //          //
        //          //  // Check result status
        //          //  switch (res.status) {
        //          //    case FacebookLoginStatus.success:
        //          //    // Logged in
        //          //
        //          //    // Send this access token to server for validation and auth
        //          //      final accessToken = res.accessToken;
        //          //      print('Access Token: ${accessToken!.token}');
        //          //
        //          //      // Get profile data
        //          //      final profile = await fb.getUserProfile();
        //          //      print(
        //          //          'Hello, ${profile!.name}! You ID: ${profile.userId}');
        //          //
        //          //      // Get email (since we request email permission)
        //          //      final email = await fb.getUserEmail();
        //          //      // But user can decline permission
        //          //      if (email != null) print('And your email is $email');
        //          //
        //          //      break;
        //          //    case FacebookLoginStatus.cancel:
        //          //    // User cancel log in
        //          //      break;
        //          //    case FacebookLoginStatus.error:
        //          //    // Log in failed
        //          //      print('Error while log in: ${res.error}');
        //          //      break;
        //          //  }
        //           final fbLogin =  FacebookLogin();
        //           Future signInFB() async {
        //             final FacebookLoginResult result = await fbLogin.logIn(customPermissions: ["email"]);
        //             final String token = result.accessToken!.token;
        //           var url = Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        //           var response = await http.get(url);
        //             //final response = await   http.get(url);  //http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        //             final profile = jsonDecode(response.body);
        //            return profile;
        //           }
        //           //Authenticate auth = Authenticate();
        //           signInFB().whenComplete(() => () {
        //           });
        //         },
        //         child: Image.asset(
        //           'images/facebook.png',
        //           height: 25.h,
        //         )),
        //     OutlinedButton(
        //         style: OutlinedButton.styleFrom(shape: const CircleBorder()),
        //         onPressed: () {},
        //         child: Image.asset(
        //           'images/apple.png',
        //           height: 20.h,
        //         )),
        //   ],
        // ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account ? ",
                style: size(18.sp, Colors.black, true)),
            TextButton(
                onPressed: () {
                  Get.to(() => SignIn());
                },
                child: Text("Sign up", style: size(18.sp, Colors.orange, true)))
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        Center(
            child: Text("By creating an account , you accept Spark's",
                style: size(15.sp, Colors.black, false))),
        Center(
            child: Text("Terms of Service and Privacy Policy",
                style: size(17.sp, Colors.orange, true)))
      ],
    ),
  );
}
