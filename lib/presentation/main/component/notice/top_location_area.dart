import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
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
              children: [
                Assets.icons.icBell.svg(),
                // 봐야할 알림이 있으면 나타냄.
                if (state.notices.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
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
}
