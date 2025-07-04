
import 'package:flutter/cupertino.dart';

@immutable
class LogicState {}


class LogicInitial extends LogicState{}

class LogicLoading extends LogicState {}

class LogicLoaded extends LogicState {}

class LogicError extends LogicState {}