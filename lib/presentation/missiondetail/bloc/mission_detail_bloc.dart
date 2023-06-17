import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/request/request_post_mission_clear.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_mission_detail_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/post_mission_clear_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'mission_detail.dart';

class MissionDetailBloc extends Bloc<MissionDetailEvent, MissionDetailState>
    with SideEffectBlocMixin<MissionDetailEvent, MissionDetailState, MissionDetailSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final GetMissionDetailUseCase getMissionDetailUseCase;
  final PostMissionClearUseCase postMissionClearUseCase;

  MissionDetailBloc({
    required this.getMissionDetailUseCase,
    required this.postMissionClearUseCase,
  }) : super(MissionDetailState.initial()) {
    on<MissionDetailInit>(init);
    on<MissionDetailExchange>(requestExchange);
  }

  FutureOr<void> init(
    MissionDetailInit event,
    Emitter<MissionDetailState> emit,
  ) async {
    await getMissionDetailUseCase(event.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailError(l)),
        (r) {
          emit(
            state.copyWith(
              entity: r,
              isLoading: false,
              isEnableButton: r.isEnableMissionClear,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> requestExchange(
    MissionDetailExchange event,
    Emitter<MissionDetailState> emit,
  ) async {
    await postMissionClearUseCase(
      RequestPostMissionClear(
        missionId: state.entity.mission.id,
        email: "melow2@naver.com",
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailError(l)),
        (r) {
          produceSideEffect(MissionClearSuccess());
        },
      ),
    );
  }
}
