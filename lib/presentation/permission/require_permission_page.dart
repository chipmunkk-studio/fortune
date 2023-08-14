import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/request_permission.dart';

class _RequestPermissionEntity {
  final SvgPicture icon;
  final String title;
  final String subTitle;

  _RequestPermissionEntity({
    required this.title,
    required this.subTitle,
    required this.icon,
  });
}

class RequestPermissionPage extends StatelessWidget {
  const RequestPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<RequestPermissionBloc>()..add(RequestPermissionInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: ''),
        child: const _RequestPermissionPage(),
      ),
    );
  }
}

class _RequestPermissionPage extends StatefulWidget {
  const _RequestPermissionPage({Key? key}) : super(key: key);

  @override
  State<_RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<_RequestPermissionPage> {
  final _router = serviceLocator<FortuneRouter>().router;
  late RequestPermissionBloc _bloc;

  final _permissionItems = [
    _RequestPermissionEntity(
      icon: Assets.icons.icPhone.svg(),
      title: "전화/SMS(필수)",
      subTitle: "휴대폰 번호 본인 인증",
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icMappin.svg(),
      title: "위치(필수)",
      subTitle: "현재 위치 확인 및 메인서비스 이용",
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icImage.svg(),
      title: "사진(선택)",
      subTitle: "프로필 이미지 설정",
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icBell.svg(),
      title: "알림(선택)",
      subTitle: "알림 수신",
    ),
  ];

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('권한 요청');
    _bloc = BlocProvider.of<RequestPermissionBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RequestPermissionBloc, RequestPermissionSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is RequestPermissionStart) {
          AppMetrica.reportEvent('권한 요청 시작');
          FortunePermissionUtil.requestPermission(_bloc.state.permissions);
        } else if (sideEffect is RequestPermissionFail) {
          AppMetrica.reportEvent('권한 요청 팝업');
          context.showFortuneDialog(
            title: '권한 요청',
            subTitle: '허용하지 않은 필수 권한이 있어요.',
            btnOkText: '이동',
            btnOkPressed: () {
              openAppSettings();
            },
          );
        } else if (sideEffect is RequestPermissionSuccess) {
          _router.navigateTo(
            context,
            _bloc.state.nextLandingRoute,
            clearStack: true,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "서비스 이용을 위해\n권한 허용이 필요해요",
            style: FortuneTextStyle.headLine3(),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 40),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: _permissionItems.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 32),
            itemBuilder: (context, index) => _itemPermission(_permissionItems[index]),
          ),
          const SizedBox(height: 40),
          Text(
            "선택 권한의 경우 허용하지 않으셔도 서비스를 이용하실 수 있으나, "
            "일부 서비스 이용이 제한될 수 있습니다.",
            style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark),
          ),
          const Spacer(),
          FortuneScaleButton(
            text: 'next'.tr(),
            press: () => _bloc.add(RequestPermissionNext()),
          )
        ],
      ),
    );
  }

  Row _itemPermission(_RequestPermissionEntity permissionItem) {
    return Row(
      children: [
        permissionItem.icon,
        const SizedBox(width: 28),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              permissionItem.title,
              style: FortuneTextStyle.body2Regular(),
            ),
            const SizedBox(height: 4),
            Text(
              permissionItem.subTitle,
              style: FortuneTextStyle.body2Regular(fontColor: ColorName.activeDark),
            ),
          ],
        )
      ],
    );
  }
}
