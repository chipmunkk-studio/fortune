import 'package:equatable/equatable.dart';

class CountryCodeEntity extends Equatable {
  final String iso2;
  final String iso3;
  final String phoneCode;
  final String eName;
  final String kName;

  const CountryCodeEntity({
    required this.iso2,
    required this.iso3,
    required this.phoneCode,
    required this.eName,
    required this.kName,
  });

  @override
  List<Object?> get props => [phoneCode];
}
