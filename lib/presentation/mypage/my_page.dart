import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/message_ext.dart';
import 'package:foresh_flutter/core/util/image_picker.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/mypage/bloc/my_page.dart';
import 'package:foresh_flutter/presentation/mypage/component/info_menu.dart';
import 'package:foresh_flutter/presentation/mypage/component/profile_info.dart';
import 'package:foresh_flutter/presentation/mypage/component/switch_menu.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'component/my_page_skeleton.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MyPageBloc>()..add(MyPageInit()),
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
  late MyPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MyPageBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MyPageBloc, MyPageSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is MyPageError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: FortuneTr.myInfo),
        child: BlocBuilder<MyPageBloc, MyPageState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            return Skeleton(
              isLoading: state.isLoading,
              skeleton: const MyPageSkeleton(),
              child: Column(
                children: [
                  BlocBuilder<MyPageBloc, MyPageState>(
                    buildWhen: (previous, current) => previous.user != current.user,
                    builder: (context, state) {
                      return ProfileInfo(
                        entity: state.user,
                        onNicknameModifyTap: () {},
                        onGradeGuideTap: () => router.navigateTo(context, Routes.gradeGuideRoute),
                        onProfileTap: () {
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
                    icon: Assets.icons.icMegaphone.svg(),
                    onTap: () => router.navigateTo(context, Routes.noticesRoutes),
                  ),
                  InfoMenu(
                    FortuneTr.faq,
                    icon: Assets.icons.icQuestion.svg(),
                    onTap: () => router.navigateTo(context, Routes.faqsRoute),
                  ),
                  BlocBuilder<MyPageBloc, MyPageState>(
                    buildWhen: (previous, current) => previous.isAllowPushAlarm != current.isAllowPushAlarm,
                    builder: (context, state) {
                      return SwitchMenu(
                        FortuneTr.pushAlarm,
                        isOn: state.isAllowPushAlarm,
                        onTap: (isOn) => _bloc.add(MyPageUpdatePushAlarm(isOn)),
                        icon: Assets.icons.icPushAlarm.svg(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
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
