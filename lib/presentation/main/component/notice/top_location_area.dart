import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/util/textstyle.dart';

import '../../bloc/main.dart';

class TopLocationArea extends StatelessWidget {
  final Function0 onProfileTap;
  final Function0 onHistoryTap;

  const TopLocationArea({
    Key? key,
    required this.onProfileTap,
    required this.onHistoryTap,
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
            Bounceable(
              onTap: onHistoryTap,
              child: Assets.icons.icSearch24.svg(),
            ),
            const SizedBox(width: 20),
            Bounceable(
              onTap: onProfileTap,
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
