import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_notice_entity.dart';

class RewardNotices extends StatelessWidget {
  const RewardNotices(
    this.notices, {
    super.key,
  });

  final List<RewardNoticeEntity> notices;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notices
          .map(
            (e) => Column(
              children: [
                Text(
                  "${e.title}",
                  style: FortuneTextStyle.body2Regular(),
                ),
                Text(
                  "${e.title}",
                  style: FortuneTextStyle.body2Regular(),
                ),
                Text(
                  "${e.title}",
                  style: FortuneTextStyle.body2Regular(),
                ),
                Text(
                  "${e.title}",
                  style: FortuneTextStyle.body2Regular(),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
