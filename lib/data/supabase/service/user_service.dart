import 'dart:io';

import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/notification/notification_manager.dart';
import 'package:fortune/core/util/ints.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
import 'package:fortune/data/supabase/response/fortune_user_ranking_response.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_ranking_entity.dart';
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
    String email, {
    required RequestFortuneUser request,
  }) async {
    try {
      Map<String, dynamic> updateMap = request.toJson();

      // null인 필드는 업데이트 대상에서 제외
      updateMap.removeWhere((key, value) => value == null);

      final updateUser = await _client
          .from(_userTableName)
          .update(updateMap)
          .eq(
            'email',
            email,
          )
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
    final fullName = "${_client.auth.currentUser?.email}/$timestamp.webp";

    final String path = await storage
        .from(
          BucketName.userProfile,
        )
        .upload(
          fullName,
          uploadFile,
          fileOptions: const FileOptions(
            cacheControl: '86400',
            upsert: false,
          ),
        );

    final String imagePath = storage
        .from(
          BucketName.userProfile,
        )
        .getPublicUrl(fullName);

    return imagePath;
  }

  // 휴대폰 번호로 사용자를 찾음.
  Future<FortuneUserEntity?> findUserByEmail(
    String email, {
    required List<UserColumn> columnsToSelect,
  }) async {
    try {
      final selectColumns = columnsToSelect.map((column) => column.name).toList();

      final List<dynamic> response = await _client
          .from(
            _userTableName,
          )
          .select(selectColumns.isEmpty ? fullSelectQuery : selectColumns.join(","))
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
    String paramEmail, {
    required int paramMarkerObtainCount,
    required int paramTicket,
    required String paramCreatedAt,
  }) async {
    const rankingColumn = 'marker_obtain_count, ticket, created_at';
    try {
      // #1 마커 카운트로 가져옴.
      final selectUsers = await _client
          .from(_userTableName)
          .select(rankingColumn)
          .filter('email', 'neq', paramEmail)
          .filter('marker_obtain_count', 'gte', paramMarkerObtainCount)
          .filter('is_withdrawal', 'eq', false)
          .toSelect();

      if (selectUsers.length >= 1000) {
        return "+999";
      }

      final List<FortuneUserRankingEntity> rankingUsers =
          selectUsers.map((e) => FortuneUserRankingResponse.fromJson(e)).toList();

      final addedUser = FortuneUserRankingResponse(
        ticket_: paramTicket,
        markerObtainCount_: paramMarkerObtainCount,
        createdAt_: paramCreatedAt,
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
            user.ticket == paramTicket &&
            user.markerObtainCount == paramMarkerObtainCount &&
            user.createdAt == paramCreatedAt,
      );

      return (myIndex + 1).toFormatThousandNumber();
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
