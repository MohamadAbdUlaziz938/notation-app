import 'dart:convert';

import 'package:flutter/material.dart';
class json_ extends StatelessWidget {
  const json_({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String response = '{"id":"mohamad","name":"Product #1"}';
    print(json.decode(response));
    //print(responseData["name"]);
    Map responseData=jsonDecode(response);
    print(responseData["name"]);
    String backtojson=jsonEncode(responseData);
    print(backtojson);
    return Container();
  }
}
