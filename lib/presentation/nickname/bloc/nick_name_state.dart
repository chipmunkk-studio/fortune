import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nick_name_state.freezed.dart';

@freezed
class NickNameState with _$NickNameState {
  factory NickNameState({
    required FortuneUserEntity userEntity,
    required String nickName,
    required bool isButtonEnabled,
  }) = _NickNameState;

  factory NickNameState.initial() => NickNameState(
        userEntity: FortuneUserEntity.empty(),
        nickName: '',
        isButtonEnabled: true,
      );
}
