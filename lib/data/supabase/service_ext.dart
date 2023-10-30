import 'dart:convert';
import 'dart:math';

import 'package:fortune/core/message_ext.dart';
import 'package:fortune/data/supabase/request/request_marker_random_insert.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_next_level_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

enum IngredientType {
  none, // 사용하지 않음.
  normal, // 일반
  coin, // 코인
  unique, // 레벨 업 시
  epic, // 등급 업.
  rare, // 릴레이 미션.
  special, // 서버 컨트롤.
}

enum AlarmFeedType {
  user,
  server,
  none,
}

enum AlarmRewardType {
  level,
  relay,
  grade,
  none,
}

extension SupabaseExt on Future<dynamic> {
  Future<List<dynamic>> toSelect() async {
    final encoded = jsonEncode(await this);
    return await jsonDecode(encoded);
  }
}

getIngredientType(String? type) {
  if (IngredientType.coin.name == type) {
    return IngredientType.coin;
  } else if (IngredientType.none.name == type) {
    return IngredientType.none;
  } else if (IngredientType.normal.name == type) {
    return IngredientType.normal;
  } else if (IngredientType.unique.name == type) {
    return IngredientType.unique;
  } else if (IngredientType.rare.name == type) {
    return IngredientType.rare;
  } else if (IngredientType.epic.name == type) {
    return IngredientType.epic;
  } else if (IngredientType.special.name == type) {
    return IngredientType.special;
  } else {
    return IngredientType.none;
  }
}

getEventNoticeType(String? type) {
  if (AlarmFeedType.server.name == type) {
    return AlarmFeedType.server;
  } else if (AlarmFeedType.user.name == type) {
    return AlarmFeedType.user;
  } else {
    return AlarmFeedType.none;
  }
}

getEventRewardType(String? type) {
  if (AlarmRewardType.level.name == type) {
    return AlarmRewardType.level;
  } else if (AlarmRewardType.relay.name == type) {
    return AlarmRewardType.relay;
  } else if (AlarmRewardType.grade.name == type) {
    return AlarmRewardType.grade;
  } else {
    return AlarmRewardType.none;
  }
}

// 랜덤 위치 받아옴.
LatLng getRandomLocation(double lat, double lon, int radiusInMeters) {
  Random random = Random();

  double radiusInDegrees = radiusInMeters / 111000; // roughly 111km per degree

  double w = radiusInDegrees * sqrt(random.nextDouble());
  double t = 2 * pi * random.nextDouble();
  double dx = w * cos(t);
  double dy = w * sin(t);

  double newLon = lon + dx / cos(lat);
  double newLat = lat + dy;

  return LatLng(newLat, newLon);
}

// 지역 이름 얻어옴.
getLocationName(
  double latitude,
  double longitude, {
  String? localeIdentifier,
  bool isDetailStreet = true,
}) async {
  final unknownLocation = FortuneTr.msgUnknownLocation;

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
      localeIdentifier: localeIdentifier,
    );

    // 장소가 없을 경우.
    if (placemarks.isEmpty) return unknownLocation;

    final pos1 = placemarks.first;
    // 상세 주소일 경우.
    if (isDetailStreet) return pos1.street ?? unknownLocation;

    final nonDetailStreet = [
      pos1.administrativeArea,
      pos1.subLocality,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    // 공백을 제거 하고 비교.
    return nonDetailStreet.isEmpty ? unknownLocation : nonDetailStreet;
  } catch (e) {
    return unknownLocation;
  }
}

// 레벨 부여 하기.
assignLevel(int markerCount) {
  int level = 1;
  while (markerCount >= level * 12) {
    markerCount -= level * 12;
    level++;
  }
  return level;
}

calculateWithdrawalDays(String withdrawalAt) {
  if (withdrawalAt.isEmpty) {
    return true;
  } else {
    return DateTime.now().difference(DateTime.parse(withdrawalAt)).inDays < 30;
  }
}

calculateLevelInfo(int markerCount) {
  int level = 1;

  while (markerCount >= level * 12) {
    markerCount -= level * 12;
    level++;
  }

  int nextLevelRequired = level * 12;
  double progressToNextLevelPercentage = (markerCount / nextLevelRequired);
  int remainingForNextLevel = nextLevelRequired - markerCount;

  // 다음 등급까지 필요한 마커 계산
  int nextGradeLevel;
  if (level < 30) {
    nextGradeLevel = 30;
  } else if (level < 60) {
    nextGradeLevel = 60;
  } else if (level < 90) {
    nextGradeLevel = 90;
  } else if (level < 120) {
    nextGradeLevel = 120;
  } else if (level < 150) {
    nextGradeLevel = 150;
  } else {
    nextGradeLevel = 999;
  }

  int totalMarkersForNextGrade = 0;
  for (int i = level + 1; i <= nextGradeLevel; i++) {
    totalMarkersForNextGrade += i * 12;
  }
  int remainingForNextGrade = totalMarkersForNextGrade - markerCount;

  // 다음 등급까지 퍼센트 계산
  double progressToNextGradePercentage = 1.0 - (remainingForNextGrade / totalMarkersForNextGrade);

  return FortuneUserNextLevelEntity(
    progressToNextLevelPercentage: progressToNextLevelPercentage,
    progressToNextGradePercentage: progressToNextGradePercentage,
    // 추가된 부분
    nextLevelMarkerCount: remainingForNextLevel,
    nextGradeMarkerCount: remainingForNextGrade,
    currentLevel: level,
  );
}

// 등급 할당.
assignGrade(int level) {
  if (level >= 120) {
    return 5; // 85680
  } else if (level >= 90) {
    return 4; // 48060
  } else if (level >= 60) {
    return 3; // 21240
  } else if (level >= 30) {
    return 2; // 5220
  } else {
    return 1;
  }
}

// 랜덤 마커 리퀘스트 생성
generateRandomMarker({
  required double lat,
  required double lon,
  required IngredientEntity ingredient,
}) {
  LatLng randomLocation = getRandomLocation(
    lat,
    lon,
    ingredient.distance,
  );
  return RequestMarkerRandomInsert(
    latitude: randomLocation.latitude,
    longitude: randomLocation.longitude,
    ingredient: ingredient.id,
  );
}
