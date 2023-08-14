// import 'package:foresh_flutter/core/util/logger.dart';
// import 'package:foresh_flutter/data/supabase/request/request_alarm_feeds.dart';
// import 'package:foresh_flutter/data/supabase/request/request_obtain_history.dart';
// import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
// import 'package:foresh_flutter/di.dart';
// import 'package:foresh_flutter/domain/supabase/repository/alarm_feeds_repository.dart';
// import 'package:foresh_flutter/domain/supabase/repository/event_rewards_repository.dart';
// import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';
// import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
// import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
//
// void main() async {
//   final rewardRepository = serviceLocator<AlarmRewardsRepository>();
//   final userRepository = serviceLocator<UserRepository>();
//   final ingredientRepository = serviceLocator<IngredientRepository>();
//   final obtainHistoryRepository = serviceLocator<ObtainHistoryRepository>();
//   final eventNoticesRepository = serviceLocator<AlarmFeedsRepository>();
//
//   final user = await userRepository.findUserByPhoneNonNull();
//   final rewardType = await rewardRepository.findRewardInfoByType(AlarmRewardType.level);
//   final ingredient = await ingredientRepository.getIngredientByRandom(rewardType);
//
//   await obtainHistoryRepository.insertObtainHistory(
//     request: RequestObtainHistory.insert(
//       ingredientId: ingredient.id,
//       userId: user.id,
//       nickName: user.nickname,
//       ingredientName: ingredient.name,
//     ),
//   );
//
//   final response = await rewardRepository.insertRewardHistory(
//     user: user,
//     alarmRewardInfo: rewardType,
//     ingredient: ingredient,
//   );
//
//   eventNoticesRepository.insertAlarm(
//     RequestEventNotices.insert(
//       type: AlarmFeedType.user.name,
//       headings: '레벨 업을 축하합니다!',
//       content: '레벨업 축하!',
//       users: user.id,
//       eventRewardHistory: response.id,
//     ),
//   );
//
//   FortuneLogger.info(response.ingredientName);
// }
