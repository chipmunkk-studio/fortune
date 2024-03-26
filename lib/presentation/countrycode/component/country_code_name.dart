import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CountryCodeName extends StatelessWidget {
  final List<CountryInfoEntity> countries;
  final CountryInfoEntity selected;
  final Axis scrollDirection;
  final AutoScrollController controller;
  final Function1<CountryInfoEntity, void> onTap;

  const CountryCodeName({
    super.key,
    required this.countries,
    required this.selected,
    required this.scrollDirection,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: scrollDirection,
      controller: controller,
      children: List.generate(
        countries.length,
        (index) {
          final country = countries[index];
          final isSelected = country.name == selected.name;
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              highlightColor: ColorName.grey800,
              child: Bounceable(
                onTap: () => onTap(country),
                child: Text(
                  "${country.name} (+${country.phoneCode})",
                  style: isSelected
                      ? FortuneTextStyle.body1Semibold(
                          color: ColorName.white,
                        )
                      : FortuneTextStyle.body1Regular(
                          color: ColorName.grey600,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
