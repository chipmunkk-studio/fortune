import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/service/common_service.dart';
import 'package:foresh_flutter/data/responses/common/announcement_response.dart';
import 'package:foresh_flutter/data/responses/common/faq_response.dart';
import 'package:foresh_flutter/domain/entities/common/announcement_entity.dart';
import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';

abstract class CommonDataSource {
  Future<AnnouncementEntity> getAnnouncement(int page);

  Future<FaqEntity> getFaq(int page);
}

class CommonDataSourceImpl extends CommonDataSource {
  final CommonService commonService;

  CommonDataSourceImpl(this.commonService);

  @override
  Future<AnnouncementEntity> getAnnouncement(int page) async {
    final response = await commonService.announcement(page: page).then((value) => value.toResponseData());
    final entity = AnnouncementResponse.fromJson(response);
    return entity;
  }

  @override
  Future<FaqEntity> getFaq(int page) async {
    final response = await commonService.faq(page: page).then((value) => value.toResponseData());
    final entity = FaqResponse.fromJson(response);
    return entity;
  }
}
