import '../../../../core/util/usecase.dart';
import '../entities/country_code_entity.dart';
import '../usecases/check_nickname_usecase.dart';

abstract class UserNormalRemoteRepository {
  Future<FortuneResult<CountryCodeListEntity>> getCountryCode();

  Future<FortuneResult<void>> checkNickname(RequestCheckNickNameParams param);
}
