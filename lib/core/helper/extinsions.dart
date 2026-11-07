import 'package:flutter/material.dart';

extension Navigation on BuildContext {
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
