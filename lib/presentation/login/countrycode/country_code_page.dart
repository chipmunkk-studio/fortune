import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../domain/entities/country_code_entity.dart';
import '../../fortune_router.dart';
import 'bloc/country_code.dart';
import 'component/country_code_name.dart';

/// 국가코드 정보.
class CountryCodeArgs {
  final String countryCode;
  final String countryName;

  CountryCodeArgs({
    required this.countryCode,
    required this.countryName,
  });
}

class CountryCodePage extends StatelessWidget {
  final String? countryCode;
  final String? countryName;

  const CountryCodePage({
    Key? key,
    this.countryCode,
    this.countryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<CountryCodeBloc>()
        ..add(
          CountryCodeInit(
            code: countryCode,
            name: countryName,
          ),
        ),
      child: const _CountryCodePage(),
    );
  }
}

class _CountryCodePage extends StatefulWidget {
  const _CountryCodePage({Key? key}) : super(key: key);

  @override
  State<_CountryCodePage> createState() => _CountryCodePageState();
}

class _CountryCodePageState extends State<_CountryCodePage> {
  final scrollDirection = Axis.vertical;
  final router = serviceLocator<FortuneRouter>().router;
  late CountryCodeBloc bloc;
  late AutoScrollController controller;

  @override
  void initState() {
    AppMetrica.reportEvent('국가코드 입력 화면');
    bloc = BlocProvider.of<CountryCodeBloc>(context);
    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: BlocSideEffectListener<CountryCodeBloc, CountryCodeSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is CountryCodeError) {
            context.handleError(sideEffect.error);
          } else if (sideEffect is CountryCodeScrollSelected) {
            _scrollToCounter(sideEffect.index);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 65),
            _buildCancelButton(),
            const SizedBox(height: 21),
            Text('select_country_code'.tr(), style: FortuneTextStyle.headLine3()),
            const SizedBox(height: 40),
            Expanded(child: _buildCountryCodeList()),
          ],
        ),
      ),
    );
  }

  /// 닫기버튼.
  GestureDetector _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        CountryCode countryCode = bloc.state.selected;
        _onPop(countryCode.code, countryCode.name);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: SvgPicture.asset("assets/icons/ic_cancel.svg"),
      ),
    );
  }

  /// 국가코드 리스트.
  BlocBuilder<CountryCodeBloc, CountryCodeState> _buildCountryCodeList() {
    return BlocBuilder<CountryCodeBloc, CountryCodeState>(
      builder: (context, state) {
        return CountryCodeName(
          countries: state.countries,
          selected: state.selected,
          scrollDirection: scrollDirection,
          controller: controller,
          onTap: (code, name) => _onPop(code, name),
        );
      },
    );
  }

  _onPop(String code, String name) {
    router.pop(
          context,
          CountryCodeArgs(
            countryCode: code,
            countryName: name,
          ),
        );
  }

  Future _scrollToCounter(int start) async {
    await controller.scrollToIndex(
      start,
      preferPosition: AutoScrollPosition.middle,
      duration: const Duration(milliseconds: 500),
    );
    controller.highlight(start);
  }
}
