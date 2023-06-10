import 'dart:convert';
import 'dart:math';

import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

extension SupabaseExt on Future<dynamic> {
  Future<List<dynamic>> toSelect() async {
    final encoded = jsonEncode(await this);
    return await jsonDecode(encoded);
  }
}

enum IngredientType { normal, ticket, adVideo, adBanner }

getIngredientType(String type) {
  if (IngredientType.ticket.name == type) {
    return IngredientType.ticket;
  } else if (IngredientType.normal.name == type) {
    return IngredientType.normal;
  } else if (IngredientType.adVideo.name == type) {
    return IngredientType.adVideo;
  } else if (IngredientType.adBanner.name == type) {
    return IngredientType.adBanner;
  } else {
    return IngredientType.normal;
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
}) async {
  // 영어
  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude, localeIdentifier: localeIdentifier);
  if (placemarks.isNotEmpty) {
    final Placemark pos = placemarks[0];
    return pos.street;
  } else {
    return "알 수 없는 위치";
  }
}

// 레벨 부여 하기.
int assignLevel(int markerCount) {
  int level = 1;
  while (markerCount >= level * 3) {
    markerCount -= level * 3;
    level++;
  }
  return level;
}

// 다음 레벨 까지 경험치 퍼센트.
double calculateLevelProgress(int markerCount) {
  int level = 1;

  while (markerCount >= level * 3) {
    markerCount -= level * 3;
    level++;
  }
  return (markerCount / (level * 3));
}

// 등급 할당.
int assignGrade(int level) {
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
RequestMarkerRandomInsert generateRandomMarker({
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
