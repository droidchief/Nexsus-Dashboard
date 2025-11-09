import 'package:flutter/material.dart';

abstract class IModule {
  String get id;
  String get title;
  IconData get icon;
  Color get color;
  Widget getWidget();
  String getRoute();
  int get priority; 
}