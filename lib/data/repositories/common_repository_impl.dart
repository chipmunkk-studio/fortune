import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/datasources/common_datasource.dart';
import 'package:foresh_flutter/domain/entities/common/announcement_entity.dart';
import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';
import 'package:foresh_flutter/domain/repositories/common_repository.dart';

class CommonRepositoryImpl implements CommonRepository {
  final CommonDataSource commonDataSource;
  final FortuneErrorMapper errorMapper;

  CommonRepositoryImpl({
    required this.commonDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<AnnouncementEntity>> getAnnouncement(int page) async {
    final remoteData = await commonDataSource.getAnnouncement(page).toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<FaqEntity>> getFaq(int page) async {
    final remoteData = await commonDataSource.getFaq(page).toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
