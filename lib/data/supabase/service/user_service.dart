import 'dart:io';

import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/notification/notification_manager.dart';
import 'package:fortune/core/util/ints.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
import 'package:fortune/data/supabase/response/fortune_user_ranking_response.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
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
        throw CommonFailure(errorMessage: FortuneTr.msgNotExistUser);
      } else {
        final user = response.map((e) => FortuneUserResponse.fromJson(e)).toList();
        return user.single;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  Future<List<FortuneUserEntity>> getAllUsersByTicketCountOrder({
    required int start,
    required int end,
  }) async {
    try {
      final List<dynamic> response = await _client
          .from(_userTableName)
          .select(fullSelectQuery)
          .filter('is_withdrawal', 'eq', false)
          .order('marker_obtain_count', ascending: false)
          .order('ticket', ascending: false)
          .order('created_at', ascending: true)
          .range(start, end)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => FortuneUserResponse.fromJson(e)).toList();
        return histories;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  Future<String> getUserRanking(
    FortuneUserEntity paramUser,
  ) async {
    const rankingColumn = 'marker_obtain_count, ticket, created_at';
    try {
      // #1 마커 카운트로 가져옴.
      final selectUsers = await _client
          .from(_userTableName)
          .select(rankingColumn)
          .filter('email', 'neq', paramUser.email)
          .filter('marker_obtain_count', 'gte', paramUser.markerObtainCount)
          .filter('is_withdrawal', 'eq', false)
          .toSelect();

      if (selectUsers.length >= 1000) {
        return "+999";
      }

      final List<FortuneUserRankingEntity> rankingUsers =
          selectUsers.map((e) => FortuneUserRankingResponse.fromJson(e)).toList();

      final addedUser = FortuneUserRankingResponse(
        ticket_: paramUser.ticket,
        markerObtainCount_: paramUser.markerObtainCount,
        createdAt_: paramUser.createdAt,
      );

      // 현재 사용자 추가.
      rankingUsers.add(addedUser);

      // 사용자 넣고 정렬.
      rankingUsers.sort((a, b) {
        // markerObtainCount를 비교.
        if (a.markerObtainCount != b.markerObtainCount) {
          return b.markerObtainCount.compareTo(a.markerObtainCount);
        }

        // markerObtainCount가 같은 경우 ticket를 비교.
        if (a.ticket != b.ticket) {
          return b.ticket.compareTo(a.ticket);
        }

        // ticket이 같은 경우 createdAt를 비교.
        return DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt));
      });

      // 인덱스로 랭킹 알 수 있음.
      final myIndex = rankingUsers.indexWhere(
        (user) =>
            user.ticket == paramUser.ticket &&
            user.markerObtainCount == paramUser.markerObtainCount &&
            user.createdAt == paramUser.createdAt,
      );

      return (myIndex + 1).toFormatThousandNumber();
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
