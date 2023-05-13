import 'package:flutter/material.dart';
import 'package:foresh_flutter/domain/entities/marker/marker_click_info_entity.dart';
import 'package:foresh_flutter/presentation/markerobtain/component/fortune_cookie.dart';

class MarkerObtainArgs {
  final MarkerClickInfoEntity? markerInfo;

  MarkerObtainArgs(
    this.markerInfo,
  );
}

class MarkerObtainPage extends StatelessWidget {
  const MarkerObtainPage(
    this.args, {
    Key? key,
  }) : super(key: key);

  final MarkerClickInfoEntity args;

  @override
  Widget build(BuildContext context) {
    if (args.grade == 1) {
      // 포츈쿠키일경우.
      return FortuneCookie(
        args.grade,
        args.message,
      );
    } else {
      return Container();
    }
  }
}
