// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:foresh_flutter/domain/supabase/usecase/get_terms_use_case.dart';
// import 'package:side_effect_bloc/side_effect_bloc.dart';
//
// import 'alarm_reward.dart';
//
// class AlarmFeedBloc extends Bloc<AlarmFeedEvent, AlarmFeedState>
//     with SideEffectBlocMixin<AlarmFeedEvent, AlarmFeedState, AlarmFeedSideEffect> {
//   final GetTermsUseCase getTermsUseCase;
//
//   AlarmFeedBloc({
//     required this.getTermsUseCase,
//   }) : super(AlarmFeedState.initial()) {
//     on<AlarmFeedInit>(init);
//   }
//
//   FutureOr<void> init(AlarmFeedInit event, Emitter<AlarmFeedState> emit) async {}
// }
