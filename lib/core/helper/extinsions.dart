import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  // اي حاجه من النوع البيلدكونتكست هتشوف الوظايف الجديده دي و اختارنا النوع ده بسبب انه موجود ف كل الفيوتشرز اللي ف التطبيق
  Future pushNamed(String route) {
    return Navigator.pushNamed(this, route);
  }

  Future pushReplacement(String route) {
    return Navigator.pushReplacementNamed(this, route);
  }

  void pushToBase(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  void pop() => Navigator.pop(this);
}
