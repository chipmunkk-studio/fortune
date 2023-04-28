import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'phone_number.dart';

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState>
    with SideEffectBlocMixin<PhoneNumberEvent, PhoneNumberState, PhoneNumberSideEffect> {
  static const tag = "[PhoneNumberBloc]";

  PhoneNumberBloc() : super(PhoneNumberState.initial()) {
    on<PhoneNumberInit>(init);
    on<PhoneNumberInput>(
      phoneNumberInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<PhoneNumberCancel>(inputCancel);
    on<PhoneNumberChangeCountryCode>(changeCountryCode);
  }

  FutureOr<void> init(PhoneNumberInit event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode ?? state.countryCode,
        countryName: event.countryName ?? state.countryName,
      ),
    );
  }

  FutureOr<void> phoneNumberInput(PhoneNumberInput event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isButtonEnabled: FortuneValidator.isValidPhoneNumber(event.phoneNumber),
      ),
    );
  }

  FutureOr<void> inputCancel(PhoneNumberCancel event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        phoneNumber: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> changeCountryCode(PhoneNumberChangeCountryCode event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode,
        countryName: event.countryName,
      ),
    );
  }
}
