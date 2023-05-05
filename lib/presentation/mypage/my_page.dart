import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_image_view.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/mypage/component/info_menu.dart';
import 'package:foresh_flutter/presentation/mypage/component/profile_info.dart';
import 'package:foresh_flutter/presentation/mypage/component/switch_menu.dart';
import 'package:foresh_flutter/presentation/mypage/component/ticket_fortune_area.dart';
import 'package:transparent_image/transparent_image.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "내정보"),
      child: const _MyPage(),
    );
  }
}

class _MyPage extends StatefulWidget {
  const _MyPage({Key? key}) : super(key: key);

  @override
  State<_MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<_MyPage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileInfo(),
        SizedBox(height: 16.h),
        TicketFortuneArea(),
        SizedBox(height: 40.h),
        InfoMenu("이용내역", icon: Assets.icons.icClock.svg(), onTap: () {}),
        InfoMenu("공지사항", icon: Assets.icons.icMegaphone.svg(), onTap: () {}),
        InfoMenu("자주 묻는 질문", icon: Assets.icons.icQuestion.svg(), onTap: () {}),
        SwitchMenu("푸시알림", onTap: () {}, icon: Assets.icons.icPushAlarm.svg()),
      ],
    );
  }

  _onPop(String code, String name) {
    router.pop(
      context,
      true,
    );
  }
}
