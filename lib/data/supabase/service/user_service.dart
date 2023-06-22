import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_user_update.dart';
import 'package:foresh_flutter/data/supabase/response/fortune_user_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserResponse;

class UserService {
  final SupabaseClient _client;

  final _userTableName = "users";

  UserService(this._client);

  // 회원가입.
  Future<void> insert({
    required String phone,
  }) async {
    try {
      await _client.from(_userTableName).insert(
            RequestFortuneUserUpdate(
              phone: phone.replaceFirst('+', ''),
              nickname: 'clover${DateTime.now().millisecondsSinceEpoch}',
              ticket: 100,
              countryCode: "82",
              markerObtainCount: 0,
              trashObtainCount: 0,
              level: 1,
            ).toJson(),
          );
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 사용자 업데이트.
  Future<FortuneUserEntity> update(
    String phoneNumber, {
    String? nickName,
    int? ticket,
    String? countryCode,
    int? markerObtainCount,
    int? trashObtainCount,
  }) async {
    try {
      FortuneUserEntity? user = await findUserByPhone(phoneNumber);
      if (user != null) {
        final level = assignLevel(markerObtainCount ?? user.markerObtainCount);
        final updateUser = await _client
            .from(_userTableName)
            .update(
              RequestFortuneUserUpdate(
                phone: user.phone,
                nickname: nickName ?? user.nickname,
                ticket: ticket ?? user.ticket,
                countryCode: countryCode ?? user.countryCode,
                markerObtainCount: markerObtainCount ?? user.markerObtainCount,
                trashObtainCount: trashObtainCount ?? user.trashObtainCount,
                level: level,
              ).toJson(),
            )
            .eq('phone', phoneNumber)
            .select();
        return updateUser.map((e) => FortuneUserResponse.fromJson(e)).toList().single;
      } else {
        throw const PostgrestException(message: '사용자가 존재하지 않습니다');
      }
    } on Exception catch (e) {
      FortuneLogger.error(e.toString());
      throw (e.handleException()); // using extension method here
    }
  }

  //
  // // 프로필 이미지 업데이트.
  // Future<bool> updateProfile(String path) async {
  //   try {
  //     await _client.from(_tableName).update(
  //       {'profile': path},
  //     ).match(
  //       {"email": _client.auth.currentUser?.email},
  //     );
  //     return true;
  //   } on PostgrestException catch (e) {
  //     throw PostgrestFailure(
  //       errorMessage: e.message,
  //       errorCode: e.code,
  //     );
  //   }
  // }

  // 휴대폰 번호로 사용자를 찾음.
  Future<FortuneUserEntity?> findUserByPhone(String? phone) async {
    try {
      final List<dynamic> response = await _client
          .from(_userTableName)
          .select("*")
          .eq(
            'phone',
            phone?.replaceFirst('+', ''),
          )
          .toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final user = response.map((e) => FortuneUserResponse.fromJson(e)).toList();
        return user.single;
      }
    } on Exception catch (e) {
      FortuneLogger.error(e.toString());
      throw (e.handleException()); // using extension method here
    }
  }
}
