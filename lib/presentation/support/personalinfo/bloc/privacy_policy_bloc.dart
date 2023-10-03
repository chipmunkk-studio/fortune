import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/get_privacy_policy_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'privacy_policy.dart';

class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState>
    with SideEffectBlocMixin<PrivacyPolicyEvent, PrivacyPolicyState, PrivacyPolicySideEffect> {
  final GetPrivacyPolicyUseCase getPrivacyPolicyUseCase;

  PrivacyPolicyBloc({
    required this.getPrivacyPolicyUseCase,
  }) : super(PrivacyPolicyState.initial()) {
    on<PrivacyPolicyInit>(init);
  }

  FutureOr<void> init(PrivacyPolicyInit event, Emitter<PrivacyPolicyState> emit) async {
    await getPrivacyPolicyUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(PrivacyPolicyError(l)),
        (r) async {
          await Future.delayed(const Duration(microseconds: 200));
          emit(
            state.copyWith(
              items: r,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }
}
