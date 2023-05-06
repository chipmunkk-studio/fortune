import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/inventory_entity.dart';
import 'package:foresh_flutter/domain/repositories/marker_repository.dart';

class ObtainInventoryUseCase implements UseCase0<InventoryEntity> {
  final MainRepository repository;

  ObtainInventoryUseCase(this.repository);

  @override
  Future<FortuneResult<InventoryEntity>> call() async {
    return await repository.getInventory();
  }
}
