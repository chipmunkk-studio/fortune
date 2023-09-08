import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

import '../../bloc/main.dart';

class TopLocationArea extends StatelessWidget {
  final Function0 onTap;

  const TopLocationArea({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      buildWhen: (previous, current) =>
          previous.locationName != current.locationName || previous.notices != current.notices,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Text(
                state.locationName,
                style: FortuneTextStyle.body1Semibold(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: onTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // todo 알림 리워드.
                  // Assets.icons.icBell.svg(),
                  // 봐야할 알림이 있으면 나타냄.
                  // if (state.notices.isNotEmpty)
                  // Positioned(
                  //   right: state.notices.length < 9 ? -13 : -20,
                  //   top: -10,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: ColorName.negative,
                  //       borderRadius: BorderRadius.circular(12.r),
                  //     ),
                  //     padding: EdgeInsets.symmetric(vertical: 2, horizontal: state.notices.length < 9 ? 6 : 5),
                  //     child: Text(
                  //       getHistoryCount(state.notices.length),
                  //       style: FortuneTextStyle.caption1SemiBold(),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            const SizedBox(width: 20),
            Bounceable(
              onTap: () {},
              child: Assets.icons.icUser.svg(),
            ),
          ],
        );
      },
    );
  }

  getHistoryCount(int length) {
    if (length < 9) {
      return length.toString();
    } else {
      return '9+';
    }
  }
}
