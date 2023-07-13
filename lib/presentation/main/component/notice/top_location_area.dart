import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

import '../../bloc/main.dart';

class TopLocationArea extends StatelessWidget {
  final MainBloc _bloc;

  const TopLocationArea(this._bloc, {Key? key}) : super(key: key);

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
                style: FortuneTextStyle.body2SemiBold(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 24),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Assets.icons.icBell.svg(),
                // 봐야할 알림이 있으면 나타냄.
                if (state.notices.isNotEmpty)
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorName.negative,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      child: Text(
                        getHistoryCount(state.notices.length),
                        style: FortuneTextStyle.caption1SemiBold(),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 20),
            Assets.icons.icUser.svg(),
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
