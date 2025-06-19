import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.folded,
    this.tablet,
    this.mobileLandscape,
    this.foldedLandscape,
    this.tabletLandscape,
  });

  final Widget? mobile;
  final Widget? mobileLandscape;
  final Widget? folded;
  final Widget? foldedLandscape;
  final Widget? tablet;
  final Widget? tabletLandscape;

  static T? _landscape<T>(BuildContext context, T? vertical, T? horizontal) {
    return ResponsiveBreakpoints.of(context).orientation ==
            Orientation.landscape
        ? horizontal
        : vertical;
  }

  @override
  Widget build(BuildContext context) {
    switch (ResponsiveBreakpoints.of(context).breakpoint.name) {
      case MOBILE:
        return _landscape(context, mobile, mobileLandscape) ??
            mobile ??
            SizedBox();
      case 'FOLDED':
        return _landscape(context, folded, foldedLandscape) ??
            folded ??
            SizedBox();
      case TABLET:
        return _landscape(context, tablet, tabletLandscape) ??
            tablet ??
            SizedBox();
      default:
        return _landscape(context, mobile, mobileLandscape) ??
            mobile ??
            SizedBox();
    }
  }

  static T of<T>(
    BuildContext context, {
    required T mobile,
    T? mobileLandscape,
    required T folded,
    T? foldedLandscape,
    required T tablet,
    T? tabletLandscape,
  }) {
    switch (ResponsiveBreakpoints.of(context).breakpoint.name) {
      case MOBILE:
        return _landscape(context, mobile, mobileLandscape) ?? mobile;
      case 'FOLDED':
        return _landscape(context, folded, foldedLandscape) ?? folded;
      case TABLET:
        return _landscape(context, tablet, tabletLandscape) ?? tablet;
      default:
        return _landscape(context, mobile, mobileLandscape) ?? mobile;
    }
  }
}
