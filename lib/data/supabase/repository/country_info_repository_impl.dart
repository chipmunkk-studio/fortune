import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/service/country_info_service.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/domain/supabase/repository/country_info_repository.dart';

class CountryInfoRepositoryImpl extends CountryInfoRepository {
  final CountryInfoService countryInfoService;

  CountryInfoRepositoryImpl({
    required this.countryInfoService,
  });

  @override
  Future<List<CountryInfoEntity>> getAllCountries() async {
    try {
      List<CountryInfoEntity> notices = await countryInfoService.findAllCountryInfo();
      return notices;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }
}
