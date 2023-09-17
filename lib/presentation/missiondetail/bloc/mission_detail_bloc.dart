import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/request/request_post_mission_clear.dart';
import 'package:fortune/domain/supabase/usecase/get_mission_detail_use_case.dart';
import 'package:fortune/domain/supabase/usecase/post_mission_clear_use_case.dart';
import 'package:http/http.dart' as http;
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
    await getMissionDetailUseCase(event.mission.mission.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailError(l)),
        (r) async {
          final particleImage = await _downloadImage(r.mission.missionReward.rewardImage);
          emit(
            state.copyWith(
              entity: r,
              isLoading: false,
              confettiImage: particleImage,
              isEnableButton: r.isEnableMissionClear,
            ),
          );
          produceSideEffect(MissionDetailTest());
        },
      ),
    );
  }

  FutureOr<void> requestExchange(
    MissionDetailExchange event,
    Emitter<MissionDetailState> emit,
  ) async {
    emit(state.copyWith(isRequestObtaining: true));
    await postMissionClearUseCase(
      RequestPostNormalMissionClear(
        missionId: state.entity.mission.id,
      ),
    ).then(
      (value) => value.fold(
        (l) {
          emit(state.copyWith(isRequestObtaining: false));
          produceSideEffect(MissionDetailError(l));
        },
        (r) {
          emit(state.copyWith(isRequestObtaining: false));
          produceSideEffect(MissionDetailClearSuccess());
        },
      ),
    );
  }

  Future<Uint8List?> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }
}
