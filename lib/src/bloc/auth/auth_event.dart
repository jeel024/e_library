
import 'package:image_picker/image_picker.dart';

abstract class AuthEvent {}

class InitEvent extends AuthEvent {}

class Google_Signin extends AuthEvent
{
  Google_Signin();
}

class Sign_out extends AuthEvent
{

  Sign_out();
}

class Email_Signin extends AuthEvent
{
  String email='',pass='',name="";
  Email_Signin(this.name,this.email, this.pass);
}

class Email_Login extends AuthEvent
{
  String email='',pass='';
  Email_Login(this.email, this.pass);
}


class Liked extends AuthEvent
{
  Map data = {};
  bool isliked;
  var wid;
  Liked(this.data,this.isliked,this.wid);
}

class Cart extends AuthEvent
{
  Map data={};
  Cart(this.data);
}

class Purchased extends AuthEvent
{
  Map m = {};
  Purchased(this.m);
}

class StoreImage extends AuthEvent
{
  XFile? image;
  StoreImage(this.image);
}
class StoreGender extends AuthEvent
{
  StoreGender();
}

class Bookdata extends AuthEvent
{

  Bookdata();
}

class UpdateCategory extends AuthEvent
{

  UpdateCategory();
}

class UpdateProfile extends AuthEvent
{
  String name,cntry;
  DateTime dob;

  UpdateProfile(this.name, this.cntry, this.dob);
}

class CreateReview extends AuthEvent
{
  Map review;

  CreateReview(this.review);
}

class GetReview extends AuthEvent
{
  String id;
  GetReview(this.id);
}

class PutCart extends AuthEvent
{
  Map m;
  PutCart(this.m);
}

class ForgrtPassword extends AuthEvent
{
  String email;

  ForgrtPassword(this.email);
}

class Cntry extends AuthEvent
{

  Cntry();
}