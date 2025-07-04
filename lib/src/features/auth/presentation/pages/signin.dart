import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/auth/auth_bloc.dart';
import '../../../../bloc/auth/auth_event.dart';
import '../../../../bloc/auth/auth_state.dart';
import '../../../../config/contants/button.dart';
import '../../../../config/contants/snackbar.dart';
import '../../../../config/contants/textfield.dart';
import '../../../../config/theme.dart';
import '../../../../config/validation.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController sign_email = TextEditingController();
  TextEditingController sign_pass = TextEditingController();
  TextEditingController re_sign_pass = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: SizedBox(height: MediaQuery.of(context).size.height*1.12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create an Account",
                    style: size(20.h, Colors.black, true),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "Name",
                    style: size(17.sp, Colors.black, false),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  email_textfield(name, "Enter Name"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Email Address",
                    style: size(17.sp, Colors.black, false),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  email_textfield(sign_email, "Enter Email here"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Password",
                    style: size(17.sp, Colors.black, false),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  pass_textfield(sign_pass, "Enter Password"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Confirm Password",
                    style: size(17.sp, Colors.black, false),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  pass_textfield(re_sign_pass, "Re-Enter Password"),
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (sign_email.text.isEmpty) {
                        errorSnackbar("Please enter email-id");
                      } else if (sign_pass.text.isEmpty) {
                        errorSnackbar("Please enter password");
                      } else if (!passvalidate(sign_pass.text)) {
                        errorSnackbar(
                            "password must contain number,character,symbol of 8 character");
                      } else if (sign_pass.text != re_sign_pass.text) {
                        errorSnackbar("Password didn't match");
                      } else {
                        BlocProvider.of<AuthBloc>(context).add(Email_Signin(
                            name.text, sign_email.text, sign_pass.text));
                      }
                    },
                    child: (BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return button("Create an Account");
                      },
                    )),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account ? ",
                          style: size(17.sp, Colors.black, true)),
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Login",
                              style: size(17.sp, Colors.orange, true)))
                    ],
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Center(
                      child: Text("By creating an account , you accept Spark's",
                          style: size(15.sp, Colors.black, false))),
                  Center(
                      child: Text("Terms of Service and Privacy Policy",
                          style: size(17.sp, Colors.orange, true))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
