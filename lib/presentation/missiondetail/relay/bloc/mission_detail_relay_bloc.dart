import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/request/request_post_mission_clear.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_mission_detail_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/post_mission_clear_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'mission_detail_relay.dart';

class MissionDetailRelayBloc extends Bloc<MissionDetailRelayEvent, MissionDetailRelayState>
    with SideEffectBlocMixin<MissionDetailRelayEvent, MissionDetailRelayState, MissionDetailRelaySideEffect> {
  static const tag = "[CountryCodeBloc]";

  final GetMissionDetailUseCase getMissionDetailUseCase;
  final PostMissionClearUseCase postMissionClearUseCase;

  MissionDetailRelayBloc({
    required this.getMissionDetailUseCase,
    required this.postMissionClearUseCase,
  }) : super(MissionDetailRelayState.initial()) {
    on<MissionDetailRelayInit>(init);
    on<MissionDetailRelayExchange>(requestExchange);
  }

  FutureOr<void> init(
    MissionDetailRelayInit event,
    Emitter<MissionDetailRelayState> emit,
  ) async {
    await getMissionDetailUseCase(event.mission.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailRelayError(l)),
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
    MissionDetailRelayExchange event,
    Emitter<MissionDetailRelayState> emit,
  ) async {
    await postMissionClearUseCase(
      RequestPostMissionClear(
        missionId: state.entity.mission.id,
        email: "melow2@naver.com",
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailRelayError(l)),
        (r) {
          produceSideEffect(MissionClearSuccess());
        },
      ),
    );
  }
}
