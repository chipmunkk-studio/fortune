import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/util/image_picker.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/mypage/component/info_menu.dart';
import 'package:foresh_flutter/presentation/mypage/component/profile_info.dart';
import 'package:foresh_flutter/presentation/mypage/component/switch_menu.dart';
import 'package:foresh_flutter/presentation/mypage/component/ticket_fortune_area.dart';
import 'package:skeletons/skeletons.dart';

import 'component/my_page_skeleton.dart';

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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: _isLoading,
      skeleton: const MyPageSkeleton(),
      child: Column(
        children: [
          ProfileInfo(
            onNicknameModifyTap: () {},
            onGradeGuideTap: () => router.navigateTo(context, Routes.gradeGuideRoute),
            onProfileTap: () {
              FortuneImagePicker().loadImagePicker(
                (path) {},
                () {},
              );
            },
          ),
          const SizedBox(height: 24),
          TicketFortuneArea(
            onTicketClick: () => router.navigateTo(context, Routes.ticketHistoryRoute),
            onMoneyClick: () => router.navigateTo(context, Routes.moneyHistoryRoute),
            onFortuneClick: () => router.navigateTo(context, Routes.fortuneHistoryRoute),
          ),
          const SizedBox(height: 32),
          InfoMenu(
            "스토어",
            icon: Assets.icons.icClock.svg(),
            onTap: () => router.navigateTo(context, Routes.storeRoute),
          ),
          InfoMenu(
            "공지사항",
            icon: Assets.icons.icMegaphone.svg(),
            onTap: () => router.navigateTo(context, Routes.announcementRoute),
          ),
          InfoMenu(
            "자주 묻는 질문",
            icon: Assets.icons.icQuestion.svg(),
            onTap: () => router.navigateTo(context, Routes.faqRoute),
          ),
          SwitchMenu(
            "푸시알림",
            onTap: () {},
            icon: Assets.icons.icPushAlarm.svg(),
          ),
        ],
      ),
    );
  }

  _onPop(String code, String name) {
    router.pop(
      context,
      true,
    );
  }
}
