import 'package:equatable/equatable.dart';

class CountryCodeListEntity extends Equatable {
  final List<CountryCode> countries;

  const CountryCodeListEntity({required this.countries});

  @override
  List<Object?> get props => [countries];
}

class CountryCode extends Equatable {
  final String code;
  final String name;

  const CountryCode({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}
