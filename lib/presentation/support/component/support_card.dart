import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class SupportCard extends StatefulWidget {
  const SupportCard({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
  }) : super(key: key);

  final String title;
  final String content;
  final String date;

  @override
  State<SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<SupportCard> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: ColorName.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: FortuneTextStyle.body1SemiBold(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              widget.date,
              style: FortuneTextStyle.body2Regular(fontColor: ColorName.activeDark),
            ),
            const SizedBox(height: 16),
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: _isExpanded
              ? Assets.icons.icArrowUp.svg(width: 20, height: 20)
              : Assets.icons.icArrowDown.svg(width: 20, height: 20),
        ),
        tilePadding: const EdgeInsets.only(
          left: 24,
          right: 20,
        ),
        onExpansionChanged: (bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        initiallyExpanded: _isExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 20,
            ),
            child: Text(
              widget.content,
              style: FortuneTextStyle.body3Bold(fontColor: ColorName.activeDark),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
