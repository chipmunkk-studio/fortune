import 'package:equatable/equatable.dart';

class MarkerClickEntity extends Equatable {
  final int chargedTickets;
  final int normalTickets;
  final bool isNew;

  const MarkerClickEntity({
    required this.chargedTickets,
    required this.normalTickets,
    required this.isNew,
  });

  @override
  List<Object?> get props => [
        chargedTickets,
        normalTickets,
        isNew,
      ];
}
