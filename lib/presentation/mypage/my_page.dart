import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/image_picker.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/presentation/mypage/bloc/my_page.dart';
import 'package:fortune/presentation/mypage/component/info_menu.dart';
import 'package:fortune/presentation/mypage/component/profile_info.dart';
import 'package:fortune/presentation/mypage/component/switch_menu.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'component/my_page_skeleton.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MyPageBloc>()..add(MyPageInit()),
      child: const _MyPage(),
    );
  }
}

class _MyPage extends StatefulWidget {
  const _MyPage();

  @override
  State<_MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<_MyPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  late MyPageBloc _bloc;

  final MixpanelTracker _tracker = serviceLocator<MixpanelTracker>();

  @override
  void initState() {
    super.initState();
    _tracker.trackEvent('마이페이지_랜딩');
    _bloc = BlocProvider.of<MyPageBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MyPageBloc, MyPageSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is MyPageError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        }
      },
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(
          context,
          title: FortuneTr.myInfo,
        ),
        child: BlocBuilder<MyPageBloc, MyPageState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            return Skeleton(
              isLoading: state.isLoading,
              skeleton: const MyPageSkeleton(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<MyPageBloc, MyPageState>(
                      buildWhen: (previous, current) => previous.user != current.user,
                      builder: (context, state) {
                        return ProfileInfo(
                          entity: state.user,
                          onNicknameModifyTap: () async {
                            _tracker.trackEvent('마이페이지_닉네임_클릭');
                            await _router.navigateTo(context, AppRoutes.nickNameRoute);
                            _bloc.add(MyPageInit());
                          },
                          onGradeGuideTap: () {
                            _tracker.trackEvent('마이페이지_등급_클릭');
                            return _router.navigateTo(context, AppRoutes.gradeGuideRoute);
                          },
                          onProfileTap: () {
                            _tracker.trackEvent('마이페이지_프로필_클릭');
                            FortuneImagePicker().loadImagePicker(
                              (path) => _bloc.add(MyPageUpdateProfile(path)),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    InfoMenu(
                      FortuneTr.notice,
                      hasNew: state.hasNewNotice,
                      icon: Assets.icons.icMegaphone.svg(),
                      onTap: () {
                        _tracker.trackEvent('마이페이지_공지사항_클릭');
                        return _router.navigateTo(context, AppRoutes.noticesRoutes);
                      },
                    ),
                    InfoMenu(
                      FortuneTr.msgMissionHistory,
                      icon: Assets.icons.icChecklist24.svg(),
                      onTap: () {
                        _tracker.trackEvent('마이페이지_미션내역_클릭');
                        return _router.navigateTo(context, AppRoutes.myMissionsRoutes);
                      },
                    ),
                    InfoMenu(
                      FortuneTr.faq,
                      icon: Assets.icons.icQuestion.svg(),
                      hasNew: state.hasNewFaq,
                      onTap: () {
                        _tracker.trackEvent('마이페이지_FAQ_클릭');
                        return _router.navigateTo(context, AppRoutes.faqsRoute);
                      },
                    ),
                    InfoMenu(
                      FortuneTr.msgPrivacyPolicy,
                      icon: Assets.icons.icNote24.svg(),
                      onTap: () {
                        _tracker.trackEvent('마이페이지_개인정보처리방침_클릭');
                        return _router.navigateTo(context, AppRoutes.privacyPolicyRoutes);
                      },
                    ),
                    BlocBuilder<MyPageBloc, MyPageState>(
                      buildWhen: (previous, current) => previous.isAllowPushAlarm != current.isAllowPushAlarm,
                      builder: (context, state) {
                        return SwitchMenu(
                          FortuneTr.pushAlarm,
                          isOn: state.isAllowPushAlarm,
                          onTap: (isOn) {
                            _tracker.trackEvent('마이페이지_알람설정_클릭');
                            _bloc.add(MyPageUpdatePushAlarm(isOn));
                          },
                          icon: Assets.icons.icPushAlarm.svg(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
