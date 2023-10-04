import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/permission.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/fortune_router.dart';
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
      title: FortuneTr.msgRequirePermissionPhone,
      subTitle: FortuneTr.msgRequirePermissionPhoneContent,
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icMappin.svg(),
      title: FortuneTr.msgRequirePermissionLocation,
      subTitle: FortuneTr.msgRequirePermissionLocationContent,
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icImage.svg(),
      title: FortuneTr.msgRequirePermissionPhoto,
      subTitle: FortuneTr.msgRequirePermissionPhotoContent,
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icBell.svg(),
      title: FortuneTr.msgRequirePermissionNotice,
      subTitle: FortuneTr.msgRequirePermissionNoticeContent,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
          FortunePermissionUtil.requestPermission(_bloc.state.permissions);
        } else if (sideEffect is RequestPermissionFail) {
          dialogService.showFortuneDialog(
            context,
            title: FortuneTr.msgRequirePermissionTitle,
            subTitle: FortuneTr.msgRequirePermissionSubTitle,
            btnOkText: FortuneTr.move,
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
            FortuneTr.msgRequirePermission,
            style: FortuneTextStyle.headLine1(),
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
            FortuneTr.msgRequirePermissionContent,
            style: FortuneTextStyle.body3Light(color: ColorName.grey200),
          ),
          const Spacer(),
          FortuneScaleButton(
            text: FortuneTr.next,
            onPress: () => _bloc.add(RequestPermissionNext()),
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
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permissionItem.title,
                style: FortuneTextStyle.body1Semibold(),
              ),
              const SizedBox(height: 4),
              Text(
                permissionItem.subTitle,
                style: FortuneTextStyle.body2Light(fontColor: ColorName.grey200),
              ),
            ],
          ),
        )
      ],
    );
  }
}
