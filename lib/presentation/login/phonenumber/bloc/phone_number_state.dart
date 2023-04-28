import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number_state.freezed.dart';

@freezed
class PhoneNumberState with _$PhoneNumberState{
  factory PhoneNumberState({
    required String phoneNumber,
    required bool isButtonEnabled,
    required String countryCode,
    required String countryName,
  }) = _PhoneNumberState;

  factory PhoneNumberState.initial() => PhoneNumberState(
        phoneNumber: "",
        isButtonEnabled: false,
        countryCode: '+82',
        countryName: 'default_country_name'.tr(),
      );

}
