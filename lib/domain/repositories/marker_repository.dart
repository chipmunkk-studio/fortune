import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:foresh_flutter/domain/entities/marker_click_entity.dart';
import 'package:foresh_flutter/domain/usecases/click_marker_usecase.dart';
import 'package:foresh_flutter/domain/usecases/main_usecase.dart';

abstract class MainRepository {
  Future<FortuneResult<MarkerClickEntity>> clickMarker(RequestPostMarkerParams params);

  Future<FortuneResult<MainEntity>> getMarkerList(RequestMainParams params);
}
