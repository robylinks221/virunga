import 'package:flutter/material.dart';

class VirungaNavigator {
  const VirungaNavigator._();

  static Future<T?> open<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> replace<T, TO>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void back<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }
}
