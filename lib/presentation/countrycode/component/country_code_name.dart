import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/locale.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/presentation/countrycode/bloc/country_code.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CountryCodeName extends StatelessWidget {
  final List<CountryInfoEntity> countries;
  final CountryCode selected;
  final Axis scrollDirection;
  final AutoScrollController controller;
  final Function2 onTap;

  const CountryCodeName({
    Key? key,
    required this.countries,
    required this.selected,
    required this.scrollDirection,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: scrollDirection,
      controller: controller,
      children: List.generate(
        countries.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: buildListItem(
              code: countries[index].phoneCode,
              name: getCurrentCountryCode() == 'KR' ? countries[index].krName : countries[index].enName,
              isSelected: countries[index].phoneCode == selected.code,
              index: index,
            ),
          );
        },
      ),
    );
  }

  /// 국가코드
  buildListItem({
    required int code,
    required String name,
    required bool isSelected,
    required int index,
  }) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: controller,
      index: index,
      highlightColor: ColorName.grey400,
      child: GestureDetector(
        onTap: () {
          onTap(code, name);
        },
        child: Text(
          "$name ($code)",
          style: isSelected
              ? FortuneTextStyle.body1Semibold(
                  fontColor: ColorName.grey500,
                )
              : FortuneTextStyle.body1Light(
                  fontColor: ColorName.grey900,
                ),
        ),
      ),
    );
  }
}
