import '../../../../core/util/usecase.dart';
import '../entities/country_code_entity.dart';
import '../repositories/user_normal_remote_repository.dart';

class ObtainCountryCodeUseCase implements UseCase0<CountryCodeListEntity> {
  final UserNormalRemoteRepository repository;

  ObtainCountryCodeUseCase(this.repository);

  @override
  Future<FortuneResult<CountryCodeListEntity>> call() async {
    return await repository.getCountryCode();
  }
}
