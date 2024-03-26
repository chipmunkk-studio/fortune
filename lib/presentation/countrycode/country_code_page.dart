import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/country_code.dart';
import 'component/country_code_name.dart';

class CountryCodePage extends StatelessWidget {
  final CountryInfoEntity args;

  const CountryCodePage(
    this.args, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<CountryCodeBloc>()
        ..add(
          CountryCodeInit(
            code: args.phoneCode,
            name: args.name,
          ),
        ),
      child: const _CountryCodePage(),
    );
  }
}

class _CountryCodePage extends StatefulWidget {
  const _CountryCodePage();

  @override
  State<_CountryCodePage> createState() => _CountryCodePageState();
}

class _CountryCodePageState extends State<_CountryCodePage> {
  final _scrollDirection = Axis.vertical;
  final _router = serviceLocator<FortuneAppRouter>().router;
  late CountryCodeBloc _bloc;
  late AutoScrollController _controller;

  @override
  void initState() {
    _bloc = BlocProvider.of<CountryCodeBloc>(context);
    _controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: _scrollDirection,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: BlocSideEffectListener<CountryCodeBloc, CountryCodeSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is CountryCodeError) {
            dialogService.showAppErrorDialog(context, sideEffect.error);
          } else if (sideEffect is CountryCodeScrollSelected) {
            _scrollToCounter(sideEffect.index);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 65.h),
            _buildCancelButton(),
            SizedBox(height: 21.h),
            Text(
              FortuneTr.countryCode,
              style: FortuneTextStyle.headLine1(),
            ),
            SizedBox(height: 40.h),
            Expanded(child: _buildCountryCodeList()),
          ],
        ),
      ),
    );
  }

  /// 닫기버튼.
  GestureDetector _buildCancelButton() {
    return GestureDetector(
      onTap: () => _onPop(_bloc.state.selected),
      child: Align(
        alignment: Alignment.topRight,
        child: SvgPicture.asset("assets/icons/ic_cancel.svg"),
      ),
    );
  }

  /// 국가코드 리스트.
  BlocBuilder<CountryCodeBloc, CountryCodeState> _buildCountryCodeList() {
    return BlocBuilder<CountryCodeBloc, CountryCodeState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Skeleton(
          isLoading: state.isLoading,
          skeleton: const Center(
            child: CircularProgressIndicator(
              color: ColorName.primary,
            ),
          ),
          child: CountryCodeName(
            countries: state.countries,
            selected: state.selected,
            scrollDirection: _scrollDirection,
            controller: _controller,
            onTap: _onPop,
          ),
        );
      },
    );
  }

  _onPop(CountryInfoEntity entity) {
    _router.pop(
      context,
      entity,
    );
  }

  Future _scrollToCounter(int start) async {
    await _controller.scrollToIndex(
      start,
      preferPosition: AutoScrollPosition.middle,
      duration: const Duration(milliseconds: 500),
    );
    _controller.highlight(start);
  }
}
