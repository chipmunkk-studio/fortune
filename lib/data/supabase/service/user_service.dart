import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/user_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserResponse;

class UserService {
  static const _tag = '[UserService] ';
  final SupabaseClient _client;

  final _userTableName = "user";

  UserService(this._client);

  // 회원가입.
  Future<void> insert({
    required String phone,
  }) async {
    try {
      await _client.from(_userTableName).insert(
            UserResponse(
              phone_: phone,
              nickname_: 'clover${DateTime.now().millisecondsSinceEpoch}',
            ).toJson(),
          );
    } on PostgrestException catch (e) {
      throw CommonFailure(
        errorCode: e.code,
        errorMessage: e.message,
        exposureMessage: "회원가입 실패.",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 사용자 업데이트.
  Future<void> update(
    String phoneNumber, {
    String? nickName,
  }) async {
    try {
      UserEntity? user = await findUserByPhone(phoneNumber);
      if (user != null) {
        await _client
            .from(_userTableName)
            .update(
              UserResponse(
                phone_: user.phone,
                nickname_: nickName ?? user.nickname,
              ).toJson(),
            )
            .eq("phone", user.phone);
      } else {
        throw const PostgrestException(message: '사용자가 존재하지 않습니다');
      }
    } on PostgrestException catch (e) {
      throw CommonFailure(
        errorCode: e.code,
        errorMessage: e.message,
        exposureMessage: "사용자 정보 업데이트 실패",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
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
  Future<UserEntity?> findUserByPhone(String phone) async {
    try {
      final List<dynamic> response = await _client.from(_userTableName).select("*").eq("phone", phone).toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final user = response.map((e) => UserResponse.fromJson(e)).toList();
        return user.single;
      }
    } on PostgrestException catch (e) {
      throw CommonFailure(
        errorCode: e.code,
        errorMessage: e.message,
        exposureMessage: "사용자를 찾을 수 없습니다.",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }
}
