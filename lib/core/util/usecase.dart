import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';


typedef FortuneResult<T> = Either<FortuneFailure, T>;

class Empty {}

abstract class UseCase0<Type> {
  Future<FortuneResult<Type>> call();
}

abstract class UseCase1<Type, Params> {
  Future<FortuneResult<Type>> call(Params params);
}
