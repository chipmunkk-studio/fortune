import 'dart:io';

import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/notification/notification_manager.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserResponse;

class UserService {
  final SupabaseClient _client = Supabase.instance.client;
  final _userTableName = TableName.users;
  final FortuneNotificationsManager notificationManager;

  static const fullSelectQuery = '*';

  UserService({
    required this.notificationManager,
  });

  // 회원가입.
  Future<void> insert({
    required String email,
  }) async {
    final pushToken = await notificationManager.getFcmPushToken();
    try {
      final requestToJson = RequestFortuneUser.insert(
        email: email,
        nickname: 'fortune${DateTime.now().millisecondsSinceEpoch}',
        pushToken: pushToken,
      ).toJson();
      FortuneLogger.info('회원가입 정보: $requestToJson');
      await _client.from(_userTableName).insert(requestToJson);
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 사용자 업데이트.
  Future<FortuneUserEntity> update(
    FortuneUserEntity user, {
    required RequestFortuneUser request,
    bool isCancelWithdrawal = false,
  }) async {
    try {
      final requestToUpdate = RequestFortuneUser(
        email: request.email ?? user.email,
        nickname: request.nickname ?? user.nickname,
        profileImage: request.profileImage ?? user.profileImage,
        ticket: request.ticket ?? user.ticket,
        markerObtainCount: request.markerObtainCount ?? user.markerObtainCount,
        level: assignLevel(request.markerObtainCount ?? user.markerObtainCount),
        pushToken: request.pushToken ?? user.pushToken,
        isWithdrawal: request.isWithdrawal ?? user.isWithdrawal,
        withdrawalAt: isCancelWithdrawal ? null : request.withdrawalAt,
      );

      final updateUser = await _client
          .from(_userTableName)
          .update(
            requestToUpdate.toJson(),
          )
          .eq('email', user.email)
          .select();

      return updateUser.map((e) => FortuneUserResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 프로필 사진 업데이트 후 url 가져 오기.
  Future<String> getUpdateProfileFileUrl({
    required String filePath,
  }) async {
    final storage = _client.storage;
    final dynamic uploadFile = File(filePath);
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';
    final fullName = "${_client.auth.currentUser?.email}/$timestamp.jpg";

    final String path = await storage
        .from(
          BucketName.userProfile,
        )
        .upload(
          fullName,
          uploadFile,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: false,
          ),
        );

    final String imagePath = storage.from(BucketName.userProfile).getPublicUrl(fullName);

    return imagePath;
  }

  // 휴대폰 번호로 사용자를 찾음.
  Future<FortuneUserEntity?> findUserByEmail(String? email) async {
    try {
      final List<dynamic> response = await _client
          .from(
            _userTableName,
          )
          .select(fullSelectQuery)
          .eq('email', email)
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
  Future<FortuneUserEntity> findUserByEmailNonNull(String? email) async {
    try {
      final List<dynamic> response = await _client
          .from(
            _userTableName,
          )
          .select(fullSelectQuery)
          .eq('email', email)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: FortuneTr.notExistUser);
      } else {
        final user = response.map((e) => FortuneUserResponse.fromJson(e)).toList();
        return user.single;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
