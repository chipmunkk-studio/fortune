import 'dart:io';

import 'package:foresh_flutter/core/error/failure/common_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/message_ext.dart';
import 'package:foresh_flutter/data/supabase/request/request_fortune_user.dart';
import 'package:foresh_flutter/data/supabase/response/fortune_user_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserResponse;

class UserService {
  final SupabaseClient _client = Supabase.instance.client;
  final _tableName = TableName.users;

  String? get phoneNumber => _client.auth.currentUser?.phone;

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
        profileImage: request.profileImage ?? user.profileImage,
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

  // 프로필 업데이트
  Future<FortuneUserEntity> updateProfile(
    FortuneUserEntity user, {
    required String filePath,
  }) async {
    try {
      final storage = _client.storage;
      final uploadFile = File(filePath);
      final now = DateTime.now();
      final timestamp = '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';
      final fullName = "${_client.auth.currentUser?.phone}/$timestamp.jpg";

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

      return await update(
        user.phone,
        request: RequestFortuneUser(
          profileImage: imagePath,
        ),
      );
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

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
