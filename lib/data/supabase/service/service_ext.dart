import 'dart:convert';
import 'dart:math';

import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_next_level_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

enum IngredientType {
  normal,
  ticket,
  unique,
}

enum AlarmFeedType {
  user,
  server,
  none,
}

enum AlarmRewardType {
  level,
  event,
  relay,
  none,
}

extension SupabaseExt on Future<dynamic> {
  Future<List<dynamic>> toSelect() async {
    final encoded = jsonEncode(await this);
    return await jsonDecode(encoded);
  }
}

getIngredientType(String type) {
  if (IngredientType.ticket.name == type) {
    return IngredientType.ticket;
  } else if (IngredientType.normal.name == type) {
    return IngredientType.normal;
  } else if (IngredientType.unique.name == type) {
    return IngredientType.unique;
  } else {
    return IngredientType.normal;
  }
}

getEventNoticeType(String type) {
  if (AlarmFeedType.server.name == type) {
    return AlarmFeedType.server;
  } else if (AlarmFeedType.user.name == type) {
    return AlarmFeedType.user;
  } else {
    return AlarmFeedType.none;
  }
}

getEventRewardType(String type) {
  if (AlarmRewardType.level.name == type) {
    return AlarmRewardType.level;
  } else if (AlarmRewardType.event.name == type) {
    return AlarmRewardType.event;
  } else if (AlarmRewardType.relay.name == type) {
    return AlarmRewardType.relay;
  } else {
    return AlarmRewardType.none;
  }
}

// 랜덤 위치 받아옴.
getRandomLocation(double lat, double lon, int radiusInMeters) {
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
  const unknownLocation = '알 수 없는 위치';
  try {
    // 영어
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
      localeIdentifier: localeIdentifier,
    );

    if (placemarks.isNotEmpty) {
      final Placemark pos1 = placemarks[0];
      String? name = pos1.name;
      String? subLocality = pos1.subLocality;
      String? locality = pos1.locality;
      String? administrativeArea = pos1.administrativeArea;
      String? postalCode = pos1.postalCode;
      String? country = pos1.country;
      if (isDetailStreet) {
        return pos1.street; // 서울특별시 성동구
      } else {
        return "$administrativeArea $subLocality";
      }
    } else {
      return unknownLocation;
    }
  } catch (e) {
    FortuneLogger.error(message: e.toString());
    return unknownLocation;
  }
}

// 레벨 부여 하기.
assignLevel(int markerCount) {
  int level = 1;
  while (markerCount >= level * 3) {
    markerCount -= level * 3;
    level++;
  }
  return level;
}

calculateLevelInfo(int markerCount) {
  int level = 1;

  while (markerCount >= level * 3) {
    markerCount -= level * 3;
    level++;
  }

  int nextLevelRequired = level * 3;
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
  } else {
    nextGradeLevel = level;
  }

  int totalMarkersForNextGrade = 0;
  for (int i = level + 1; i <= nextGradeLevel; i++) {
    totalMarkersForNextGrade += i * 3;
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
    return 5;
  } else if (level >= 90) {
    return 4;
  } else if (level >= 60) {
    return 3;
  } else if (level >= 30) {
    return 2;
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
