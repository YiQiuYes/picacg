import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({super.key, this.mobile, this.folded, this.tablet});

  final Widget? mobile;
  final Widget? folded;
  final Widget? tablet;

  @override
  Widget build(BuildContext context) {
    switch (ResponsiveBreakpoints.of(context).breakpoint.name) {
      case MOBILE:
        return mobile ?? SizedBox();
      case 'FOLDED':
        return folded ?? SizedBox();
      case TABLET:
        return tablet ?? SizedBox();
      default:
        return mobile ?? SizedBox();
    }
  }
}
