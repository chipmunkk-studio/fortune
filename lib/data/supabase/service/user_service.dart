import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/message_ext.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:foresh_flutter/data/supabase/request/request_fortune_user.dart';
import 'package:foresh_flutter/data/supabase/response/fortune_user_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserResponse;

class UserService {
  final SupabaseClient _client = Supabase.instance.client;
  final _tableName = TableName.users;

  UserService();

  // 회원가입.
  Future<void> insert({
    required String phone,
  }) async {
    try {
      await _client.from(_tableName).insert(
            RequestFortuneUser.insert(
              phone: phone.replaceFirst('+', ''),
              nickname: 'clover${DateTime.now().millisecondsSinceEpoch}',
            ).toJson(),
          );
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 사용자 업데이트.
  Future<FortuneUserEntity> update(
    String phoneNumber, {
    required RequestFortuneUser request,
  }) async {
    try {
      FortuneUserEntity? user = await findUserByPhoneNonNull(phoneNumber);
      // 다음 레벨.
      final level = assignLevel(request.markerObtainCount ?? user.markerObtainCount);

      final requestToUpdate = RequestFortuneUser(
        phone: request.phone ?? user.phone,
        nickname: request.nickname ?? user.nickname,
        ticket: request.ticket ?? user.ticket,
        markerObtainCount: request.markerObtainCount ?? user.markerObtainCount,
        level: level,
      );

      final updateUser = await _client
          .from(_tableName)
          .update(
            requestToUpdate.toJson(),
          )
          .eq('phone', phoneNumber)
          .select();

      return updateUser.map((e) => FortuneUserResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
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
          .from(
            _tableName,
          )
          .select("*")
          .eq('phone', phone)
          .toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final user = response.map((e) => FortuneUserResponse.fromJson(e)).toList();
        return user.single;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 휴대폰 번호로 사용자를 찾음.
  Future<FortuneUserEntity> findUserByPhoneNonNull(String? phone) async {
    try {
      final List<dynamic> response = await _client
          .from(
            _tableName,
          )
          .select("*")
          .eq('phone', phone)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: FortuneCommonMessage.notExistUser);
      } else {
        final user = response.map((e) => FortuneUserResponse.fromJson(e)).toList();
        return user.single;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
