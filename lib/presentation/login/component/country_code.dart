import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/presentation/login/bloc/login.dart';

class CountryCode extends StatelessWidget {
  final Function0 onTap;

  const CountryCode({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final String countryCodeText =
            state.isLoading ? '' : "${state.selectCountry.name} (+${state.selectCountry.phoneCode})";
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 8.w,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  countryCodeText,
                  style: FortuneTextStyle.body1Light(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Assets.icons.icArrowDown.svg(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
