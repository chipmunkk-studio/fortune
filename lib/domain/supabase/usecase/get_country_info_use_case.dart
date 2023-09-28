import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/domain/supabase/repository/country_info_repository.dart';

class GetCountryInfoUseCase implements UseCase0<List<CountryInfoEntity>> {
  final CountryInfoRepository repository;

  GetCountryInfoUseCase({
    required this.repository,
  });

  @override
  Future<FortuneResult<List<CountryInfoEntity>>> call() async {
    try {
      final faqs = await repository.getAllCountries();
      return Right(faqs);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
