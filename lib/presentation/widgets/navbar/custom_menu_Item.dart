import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

class CustomMenuItem {
  final SideNavigationBarItem sideNavigationBarItem;
  Widget? page;
  final String route;

  CustomMenuItem(
      {required this.sideNavigationBarItem, this.page, required this.route});
}
