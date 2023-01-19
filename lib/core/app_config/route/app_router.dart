import 'package:flutter/material.dart';

// Route<dynamic> _getRoute(RouteSettings settings) {
//   if (settings.name == '/foo') {
//     // FooRoute constructor expects SomeObject
//     return _buildRoute(settings, FooRoute(settings.arguments));
//   }
//
//   return null;
// }

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (ctx) => builder,
  );
}
