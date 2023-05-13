import 'package:equatable/equatable.dart';
import 'package:foresh_flutter/domain/entities/marker/marker_click_info_entity.dart';

class MarkerClickEntity extends Equatable {
  final int remainTicketCount;
  final MarkerClickInfoEntity obtainMarker;

  const MarkerClickEntity({
    required this.remainTicketCount,
    required this.obtainMarker,
  });

  @override
  List<Object?> get props => [
        remainTicketCount,
        obtainMarker,
      ];
}
