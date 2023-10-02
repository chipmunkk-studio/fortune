import 'package:fortune/domain/supabase/entity/country_info_entity.dart';

abstract class CountryInfoRepository {
  Future<List<CountryInfoEntity>> getAllCountries();
}
