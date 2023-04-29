import 'package:equatable/equatable.dart';

class MarkerClickEntity extends Equatable {
  final int chargedTickets;
  final int normalTickets;

  const MarkerClickEntity({
    required this.chargedTickets,
    required this.normalTickets,
  });

  @override
  List<Object?> get props => [
        chargedTickets,
        normalTickets,
      ];
}
