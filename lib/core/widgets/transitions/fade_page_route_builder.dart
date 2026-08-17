import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class FadePageRouteBuilder<T> extends PageRouteBuilder<T> {
  FadePageRouteBuilder({
    required this.page,
    super.settings,
  }) : super(pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        },);

  final Widget page;

  @override
  RouteTransitionsBuilder get transitionsBuilder {
    return (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    };
  }
}
