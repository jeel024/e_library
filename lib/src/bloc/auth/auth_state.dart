import 'package:flutter/cupertino.dart';

@immutable
class AuthState {}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthLoaded extends AuthState{}

class AuthError extends AuthState{}
