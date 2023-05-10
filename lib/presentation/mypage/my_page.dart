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
    return Skeleton(
      isLoading: false,
      skeleton: const _Skeleton(),
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
          SizedBox(height: 16.h),
          TicketFortuneArea(),
          SizedBox(height: 32.h),
          InfoMenu("스토어", icon: Assets.icons.icClock.svg(), onTap: () {}),
          InfoMenu("공지사항", icon: Assets.icons.icMegaphone.svg(), onTap: () {}),
          InfoMenu("자주 묻는 질문", icon: Assets.icons.icQuestion.svg(), onTap: () {}),
          SwitchMenu("푸시알림", onTap: () {}, icon: Assets.icons.icPushAlarm.svg()),
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

// 스켈레톤.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
                width: 84,
                height: 84,
              ),
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Column(
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 24.h,
                      width: 128.w,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  SizedBox(height: 7.h),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 24.h,
                      width: 178.w,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 84.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 31.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 324.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 12.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 256.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 12.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 128.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 12.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 312.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    );
  }
}
