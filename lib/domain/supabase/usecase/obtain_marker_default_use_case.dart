import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/presentation/main/main_ext.dart';

class ObtainMarkerDefaultUseCase implements UseCase1<FortuneUserEntity, IngredientEntity> {
  final UserRepository userRepository;
  final ObtainHistoryRepository historyRepository;

  ObtainMarkerDefaultUseCase({
    required this.userRepository,
    required this.historyRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(IngredientEntity param) async {
    try {
      // 유저 정보 가져오기
      var user = await _getUserByEmail();

      if (user.ticket >= ticketThreshold && param.rewardTicket > 0) {
        throw CommonFailure(errorMessage: FortuneTr.msgNoHasCoin);
      }

      // 조건에 따른 처리
      if (_isCoinType(param.type)) {
        user = await _updateUserTickets(user, param);
      } else {
        await _addObtainHistory(user, param);
      }
      // 결과 반환
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  Future<FortuneUserEntity> _getUserByEmail() async {
    return await userRepository.findUserByEmailNonNull(
      columnsToSelect: [
        UserColumn.id,
        UserColumn.email,
        UserColumn.nickname,
        UserColumn.profileImage,
        UserColumn.ticket,
        UserColumn.markerObtainCount,
      ],
    );
  }

  bool _isCoinType(IngredientType type) {
    return type == IngredientType.coin || type == IngredientType.multiCoin;
  }

  Future<FortuneUserEntity> _updateUserTickets(
    FortuneUserEntity user,
    IngredientEntity param,
  ) async {
    int updatedTicket = max(0, user.ticket + param.rewardTicket);
    return await userRepository.updateUserTicket(
      user.email,
      ticket: updatedTicket,
      markerObtainCount: user.markerObtainCount,
    );
  }

  Future<void> _addObtainHistory(
    FortuneUserEntity user,
    IngredientEntity param,
  ) async {
    await historyRepository.insertObtainHistory(
      request: RequestObtainHistory.insert(
        ingredientId: param.id,
        userId: user.id,
        nickName: user.nickname,
        enIngredientName: param.enName,
        krIngredientName: param.krName,
        locationName: FortuneTr.msgGiftBox,
        isReward: false,
      ),
    );
  }
}
