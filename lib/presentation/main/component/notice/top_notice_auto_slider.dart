import 'package:flutter/material.dart';

class TopNoticeAutoSlide extends StatefulWidget {
  final List<Widget> items;
  final Duration duration;
  final PageController pageController;

  const TopNoticeAutoSlide(
    this.pageController, {
    super.key,
    required this.items,
    required this.duration,
  });

  @override
  State<StatefulWidget> createState() => _TopNoticeAutoSlideState();
}

class _TopNoticeAutoSlideState extends State<TopNoticeAutoSlide> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: widget.pageController,
          itemCount: widget.items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            final item = widget.items[index];
            return item;
          },
        );
      },
    );
  }
}
