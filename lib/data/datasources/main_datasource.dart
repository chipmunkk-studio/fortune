import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_main.dart';
import 'package:foresh_flutter/core/network/api/request/request_post_marker.dart';
import 'package:foresh_flutter/core/network/api/service/main_service.dart';
import 'package:foresh_flutter/data/responses/main/main_inventory_response.dart';
import 'package:foresh_flutter/data/responses/main/main_marker_click_response.dart';
import 'package:foresh_flutter/data/responses/main/main_response.dart';
import 'package:foresh_flutter/domain/entities/inventory_entity.dart';
import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:foresh_flutter/domain/entities/marker_click_entity.dart';

abstract class MainDataSource {
  Future<MainEntity> getMarkerList(RequestMain request);

  Future<MarkerClickEntity> clickMarker(RequestPostMarker request);

  Future<InventoryEntity> getInventory();
}

class MainRemoteDataSourceImpl extends MainDataSource {
  final MainService mainService;

  MainRemoteDataSourceImpl(this.mainService);

  @override
  Future<MainEntity> getMarkerList(RequestMain request) async {
    final response = await mainService.main(request).then((value) => value.toResponseData());
    final entity = MainResponse.fromJson(response);
    return entity;
  }

  @override
  Future<MarkerClickEntity> clickMarker(RequestPostMarker request) async {
    final response = await mainService.putMarker(request).then((value) => value.toResponseData());
    final entity = MainMarkerClickResponse.fromJson(response);
    return entity;
  }

  @override
  Future<InventoryEntity> getInventory() async {
    final response = await mainService.inventory().then((value) => value.toResponseData());
    final entity = MainInventoryResponse.fromJson(response);
    return entity;
  }
}
