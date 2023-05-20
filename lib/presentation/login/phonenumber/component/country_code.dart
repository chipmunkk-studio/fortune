import 'package:dartz/dartz.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

import '../../../fortune_router.dart';
import '../../countrycode/country_code_page.dart';
import '../bloc/phone_number.dart';

class CountryCode extends StatelessWidget {
  final FluroRouter router;
  final Function1<CountryCodeArgs, void> onTap;

  const CountryCode(
    this.router, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            final CountryCodeArgs result = await router.navigateTo(
              context,
              Routes.countryCodeRoute,
              routeSettings: RouteSettings(
                arguments: CountryCodeArgs(
                  countryCode: state.countryCode,
                  countryName: state.countryName,
                ),
              ),
              replace: false,
            );
            onTap(result);
          },
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${state.countryName} (${state.countryCode})", style: FortuneTextStyle.body1Regular()),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SvgPicture.asset("assets/icons/ic_arrow_down.svg"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
