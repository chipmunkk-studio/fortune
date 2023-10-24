import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';

class FortuneScaffold extends StatelessWidget {
  final Widget child;
  final bool? bottom;
  final bool? top;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset;
  final Widget? bottomSheet;
  final EdgeInsets? padding;

  const FortuneScaffold({
    Key? key,
    required this.child,
    this.bottom,
    this.top,
    this.appBar,
    this.resizeToAvoidBottomInset = false,
    this.backgroundColor = ColorName.grey900,
    this.bottomSheet,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ?? const FortuneEmptyAppBar(),
      bottomSheet: bottomSheet,
      // 텍스트 인풋위로 올라오는 버튼 일 경우 true.
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
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
    Color? backgroundColor = ColorName.grey900,
    bool centerTitle = false,
    bool leftAlignTitle = true,
  }) =>
      AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Assets.icons.icArrowLeft.svg(),
          onPressed: onPressed ?? () => Navigator.pop(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          iconSize: 24,
        ),
        title: Text(
          title,
          style: FortuneTextStyle.subTitle2SemiBold(),
        ),
        centerTitle: centerTitle,
        titleSpacing: leftAlignTitle ? 0.0 : NavigationToolbar.kMiddleSpacing,
      );
}
