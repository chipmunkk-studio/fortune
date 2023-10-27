import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';

class ItemAlarmFeed extends StatelessWidget {
  final AlarmFeedsEntity item;
  final Function1<AlarmFeedsEntity, void> onReceive;
  final MixpanelTracker tracker;

  const ItemAlarmFeed(
    this.item, {
    super.key,
    required this.tracker,
    required this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: item.type == AlarmFeedType.server ? ColorName.primary : Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20.r),
        color: ColorName.grey800,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.icons.icGift.svg(width: 20, height: 20),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: Text(item.headings, style: FortuneTextStyle.body2Semibold())),
                        const SizedBox(width: 8),
                        Text(
                          item.createdAt,
                          style: FortuneTextStyle.caption2Regular(color: ColorName.grey200),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.content,
                      style: FortuneTextStyle.body3Light(color: ColorName.grey200, height: 1.4),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          if (item.reward.id != -1)
            Align(
              alignment: Alignment.topRight,
              child: Bounceable(
                onTap: () {
                  tracker.trackEvent('알림_받기_클릭');
                  onReceive(item);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: item.isReceive ? ColorName.grey600 : ColorName.grey100),
                    borderRadius: BorderRadius.circular(100.r),
                    color: item.isReceive ? ColorName.grey600 : ColorName.grey100,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(
                    item.isReceive ? FortuneTr.msgReceiveRewardCompleted : FortuneTr.msgReceiveReward,
                    style: FortuneTextStyle.caption1SemiBold(
                      color: item.isReceive ? ColorName.grey400 : ColorName.grey900,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
