import 'package:flutter/material.dart';
import 'package:note/utils/text.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(String content, BuildContext context, {bool hidePrevious = true, int duration = 4000, SnackBarAction action}) {
  final scaffold = ScaffoldMessenger.of(context);
  //final scaffold = Scaffold.of(context);
  if (hidePrevious) {
    scaffold.hideCurrentSnackBar();
  }
  return scaffold.showSnackBar(SnackBar(
    content: text(content),
    duration: Duration(milliseconds: duration),
    action: action,
  ));
}