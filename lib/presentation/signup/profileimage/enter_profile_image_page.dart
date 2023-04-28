import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/util/analytics.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'component/bottom_button.dart';
import 'component/profile_image.dart';

class EnterProfileImagePage extends StatelessWidget {
  const EnterProfileImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<SignUpBloc>(),
      child: const _EnterProfileImagePage(),
    );
  }
}

class _EnterProfileImagePage extends StatefulWidget {
  const _EnterProfileImagePage({Key? key}) : super(key: key);

  @override
  State<_EnterProfileImagePage> createState() => _EnterProfileImagePageState();
}

class _EnterProfileImagePageState extends State<_EnterProfileImagePage> {
  late SignUpBloc bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    bloc = BlocProvider.of<SignUpBloc>(context);
    FortuneLogger.debug("${bloc.state}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<SignUpBloc, SignUpSideEffect>(
      listener: (context, sideEffect) {
        FortuneLogger.debug("sideEffect:: $sideEffect");
        if (sideEffect is SignUpProfileError) {
          context.handleError(sideEffect.error);
        } else if (sideEffect is SignUpShowRequestStorageAuthDialog) {
          context.showFortuneDialog(
            title: '권한이 필요합니다.',
            subTitle: '갤러리 접근 권한을 허용해주세요',
            btnOkText: '허용하러 가기',
            btnOkPressed: () => AppSettings.openAppSettings(),
          );
        } else if (sideEffect is SignUpMoveNext && sideEffect.page == SignUpMoveNextPage.complete) {
          router.navigateTo(
            context,
            Routes.signUpCompleteRoute,
            clearStack: true,
          );
        }
      },
      child: FortuneScaffold(
        bottomSheet: BottomButton(bloc),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.h),
            Text('enter_profile_image'.tr(), style: FortuneTextStyle.headLine3()),
            SizedBox(height: 32.h),
            Align(
              alignment: Alignment.center,
              child: ProfileImage(bloc),
            ),
          ],
        ),
      ),
    );
  }
}
