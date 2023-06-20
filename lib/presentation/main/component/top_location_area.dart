import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

import '../bloc/main.dart';

class TopLocationArea extends StatelessWidget {
  final MainBloc _bloc;

  const TopLocationArea(this._bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.locationName,
                  style: FortuneTextStyle.body2SemiBold(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Assets.icons.icUser.svg(),
          ],
        );
      },
    );
  }
}
