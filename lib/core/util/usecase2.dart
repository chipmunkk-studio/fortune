import 'package:dartz/dartz.dart';
import 'package:fortune/data/error/fortune_error.dart';

typedef FortuneResult<T> = Either<FortuneFailure, T>;

class Empty {}

abstract class UseCase0<Type> {
  Future<FortuneResult<Type>> call();
}

abstract class UseCase1<Type, Param1> {
  Future<FortuneResult<Type>> call(Param1 param1);
}

abstract class UseCase2<Type, Param1, Param2> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
  );
}

abstract class UseCase3<Type, Param1, Param2, Param3> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
  );
}

abstract class UseCase4<Type, Param1, Param2, Param3, Param4> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
    Param4 param4,
  );
}

abstract class UseCase5<Type, Param1, Param2, Param3, Param4, Param5> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
    Param4 param4,
    Param5 param5,
  );
}

abstract class UseCase6<Type, Param1, Param2, Param3, Param4, Param5, Param6> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
    Param4 param4,
    Param5 param5,
    Param6 param6,
  );
}

abstract class UseCase7<Type, Param1, Param2, Param3, Param4, Param5, Param6, Param7> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
    Param4 param4,
    Param5 param5,
    Param6 param6,
    Param7 param7,
  );
}

abstract class UseCase8<Type, Param1, Param2, Param3, Param4, Param5, Param6, Param7, Param8> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
    Param4 param4,
    Param5 param5,
    Param6 param6,
    Param7 param7,
    Param8 param8,
  );
}

abstract class UseCase9<Type, Param1, Param2, Param3, Param4, Param5, Param6, Param7, Param8, Param9> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
    Param4 param4,
    Param5 param5,
    Param6 param6,
    Param7 param7,
    Param8 param8,
    Param9 param9,
  );
}

abstract class UseCase10<Type, Param1, Param2, Param3, Param4, Param5, Param6, Param7, Param8, Param9, Param10> {
  Future<FortuneResult<Type>> call(
    Param1 param1,
    Param2 param2,
    Param3 param3,
    Param4 param4,
    Param5 param5,
    Param6 param6,
    Param7 param7,
    Param8 param8,
    Param9 param9,
    Param10 param10,
  );
}