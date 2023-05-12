import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/fortune_history_entity.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class BottomHistoryList extends StatelessWidget {
  final List<FortuneUsageHistoryEntity> items;

  const BottomHistoryList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return StickyHeader(
          header: Container(
            width: double.infinity,
            color: ColorName.background,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Text(
              items[index].date,
              style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.activeDark),
            ),
          ),
          content: Column(
            children: items[index].items.asMap().entries.map(
              (entry) {
                int itemIndex = entry.key;
                var item = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Text(
                            item.content,
                            style: FortuneTextStyle.body1Regular(),
                          ),
                          Spacer(),
                          Text(
                            "-20",
                            style: FortuneTextStyle.body1SemiBold(fontColor: ColorName.negative),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        "${item.time}",
                        style: FortuneTextStyle.body3Regular(fontColor: ColorName.deActive),
                      ),
                    ),
                    itemIndex != items[index].items.length - 1
                        ? SizedBox(height: 24.h)
                        : Column(
                            children: [
                              SizedBox(height: 20.h),
                              Divider(
                                thickness: 12.h,
                                color: ColorName.backgroundLight,
                              ),
                            ],
                          ),
                  ],
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
