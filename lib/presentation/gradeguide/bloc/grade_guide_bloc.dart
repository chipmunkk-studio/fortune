import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/grade_guide_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'grade_guide.dart';

class GradeGuideBloc extends Bloc<GradeGuideEvent, GradeGuideState>
    with SideEffectBlocMixin<GradeGuideEvent, GradeGuideState, GradeGuideSideEffect> {
  final GradeGuideUseCase gradeGuideUseCase;

  GradeGuideBloc({
    required this.gradeGuideUseCase,
  }) : super(GradeGuideState.initial()) {
    on<GradeGuideInit>(init);
  }

  FutureOr<void> init(GradeGuideInit event, Emitter<GradeGuideState> emit) async {
    await gradeGuideUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(GradeGuideError(l)),
        (r) async {
          emit(
            state.copyWith(
              user: r.user,
            ),
          );
        },
      ),
    );
  }
}
