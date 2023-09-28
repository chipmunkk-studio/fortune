class CountryInfoEntity {
  final int id;
  final String enName;
  final String iso2;
  final String iso3;
  final int phoneCode;
  final String krName;

  CountryInfoEntity({
    required this.id,
    required this.enName,
    required this.krName,
    required this.iso2,
    required this.iso3,
    required this.phoneCode,
  });
}
