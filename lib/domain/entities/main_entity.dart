import 'package:equatable/equatable.dart';

class MainEntity extends Equatable {
  final int id;
  final List<MainMarkerEntity> markers;
  final List<MainHistoryEntity> histories;
  final String profileImageUrl;
  final int coinCount;
  final int ticketCount;
  final int roundTime;

  const MainEntity({
    required this.id,
    required this.markers,
    required this.profileImageUrl,
    required this.coinCount,
    required this.ticketCount,
    required this.roundTime,
    required this.histories,
  });

  @override
  List<Object?> get props => [id, markers];
}

class MainMarkerEntity extends Equatable {
  final double latitude;
  final double longitude;
  final int grade;
  final int id;
  final String createdAt;
  final String modifiedAt;

  const MainMarkerEntity({
    required this.latitude,
    required this.longitude,
    required this.grade,
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        grade,
        id,
        createdAt,
        modifiedAt,
      ];
}

class MainHistoryEntity extends Equatable {
  final double latitude;
  final double longitude;
  final int grade;
  final int userId;
  final String nickname;
  final int markerId;
  final int id;
  final String createdAt;
  final String modifiedAt;

  const MainHistoryEntity({
    required this.latitude,
    required this.longitude,
    required this.grade,
    required this.userId,
    required this.nickname,
    required this.markerId,
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        grade,
        userId,
        nickname,
        markerId,
        id,
        createdAt,
        modifiedAt,
      ];
}
