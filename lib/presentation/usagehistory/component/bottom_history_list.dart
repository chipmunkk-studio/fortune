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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            item.content,
                            style: FortuneTextStyle.body1Regular(),
                          ),
                          const Spacer(),
                          Text(
                            "-20",
                            style: FortuneTextStyle.body1SemiBold(fontColor: ColorName.negative),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        item.time,
                        style: FortuneTextStyle.body3Regular(fontColor: ColorName.deActive),
                      ),
                    ),
                    itemIndex != items[index].items.length - 1
                        ? const SizedBox(height: 24)
                        : const Column(
                            children: [
                              SizedBox(height: 20),
                              Divider(
                                thickness: 12,
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
