import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class FortuneScaffold extends StatelessWidget {
  final Widget child;
  final bool? bottom;
  final bool? top;
  final PreferredSizeWidget? appBar;
  final Widget? bottomSheet;
  final EdgeInsets? padding;

  const FortuneScaffold({
    Key? key,
    required this.child,
    this.bottom,
    this.top,
    this.appBar,
    this.bottomSheet,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? const FortuneEmptyAppBar(),
      bottomSheet: bottomSheet,
      body: SafeArea(
        bottom: bottom ?? true,
        top: top ?? true,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: child,
        ),
      ),
    );
  }
}

class FortuneEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FortuneEmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}

abstract class FortuneCustomAppBar {
  static leadingAppBar(
    BuildContext context, {
    String title = "",
    Function0? onPressed,
  }) =>
      AppBar(
        leading: IconButton(
          icon: Assets.icons.icArrowLeft.svg(),
          onPressed: onPressed ?? () => Navigator.pop(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          iconSize: 24,
        ),
        title: Text(
          title,
          style: FortuneTextStyle.subTitle3SemiBold(),
        ),
      );
}
