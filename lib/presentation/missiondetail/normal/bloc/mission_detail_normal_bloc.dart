import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/request/request_post_mission_clear.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_mission_detail_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/post_mission_normal_clear_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'mission_detail_normal.dart';

class MissionDetailNormalBloc extends Bloc<MissionDetailNormalEvent, MissionDetailNormalState>
    with SideEffectBlocMixin<MissionDetailNormalEvent, MissionDetailNormalState, MissionDetailNormalSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final GetMissionDetailUseCase getMissionDetailUseCase;
  final PostMissionNormalClearUseCase postMissionClearUseCase;

  MissionDetailNormalBloc({
    required this.getMissionDetailUseCase,
    required this.postMissionClearUseCase,
  }) : super(MissionDetailNormalState.initial()) {
    on<MissionDetailNormalInit>(init);
    on<MissionDetailNormalExchange>(requestExchange);
  }

  FutureOr<void> init(
    MissionDetailNormalInit event,
    Emitter<MissionDetailNormalState> emit,
  ) async {
    await getMissionDetailUseCase(event.mission.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailNormalError(l)),
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
    MissionDetailNormalExchange event,
    Emitter<MissionDetailNormalState> emit,
  ) async {
    await postMissionClearUseCase(
      RequestPostMissionClear(
        missionId: state.entity.mission.id,
        email: "melow2@naver.com",
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailNormalError(l)),
        (r) {
          produceSideEffect(MissionDetailNormalClearSuccess());
        },
      ),
    );
  }
}
