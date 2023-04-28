import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/country_code_entity.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CountryCodeName extends StatelessWidget {
  final List<CountryCode> countries;
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
              code: countries[index].code,
              name: countries[index].name,
              isSelected: countries[index].code == selected.code,
              index: index,
            ),
          );
        },
      ),
    );
  }

  /// 국가코드
  buildListItem({
    required String code,
    required String name,
    required bool isSelected,
    required int index,
  }) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: controller,
      index: index,
      highlightColor: ColorName.backgroundLight,
      child: GestureDetector(
        onTap: () {
          onTap(code, name);
        },
        child: Text(
          "$name ($code)",
          style: isSelected
              ? FortuneTextStyle.body1SemiBold(
                  fontColor: ColorName.active,
                )
              : FortuneTextStyle.body1Regular(
                  fontColor: ColorName.activeDark,
                ),
        ),
      ),
    );
  }
}
