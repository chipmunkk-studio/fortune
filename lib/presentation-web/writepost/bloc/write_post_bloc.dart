import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service/post_service.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'write_post.dart';

class WritePostBloc extends Bloc<WritePostEvent, WritePostState>
    with SideEffectBlocMixin<WritePostEvent, WritePostState, WritePostSideEffect> {
  WritePostBloc() : super(WritePostState.initial()) {
    on<WritePostInit>(init);
    on<WritePostRequest>(postJson);
  }

  FutureOr<void> init(WritePostInit event, Emitter<WritePostState> emit) async {
    // await missionsUseCase().then(
    //   (value) => value.fold(
    //     (l) => produceSideEffect(WritePostError(l)),
    //     (r) {
    //       emit(
    //         state.copyWith(
    //           isLoading: false,
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  FutureOr<void> postJson(WritePostRequest event, Emitter<WritePostState> emit) async {
    try {
      final user = await serviceLocator<UserRepository>().findUserByEmailNonNull(columnsToSelect: [UserColumn.id]);
      final service = serviceLocator<PostService>();
      await service.insert(
        users: user.id,
        content: event.postJson,
      );
    } catch (e) {
      FortuneLogger.error(message: "$e");
    }
  }
}
