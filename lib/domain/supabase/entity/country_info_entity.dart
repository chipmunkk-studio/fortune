class CountryInfoEntity {
  final int id;
  final String name;
  final String iso2;
  final String iso3;
  final int phoneCode;

  CountryInfoEntity({
    required this.id,
    required this.name,
    required this.iso2,
    required this.iso3,
    required this.phoneCode,
  });

  factory CountryInfoEntity.empty() {
    return CountryInfoEntity(
      id: -1,
      name: '',
      iso2: '',
      iso3: '',
      phoneCode: -1,
    );
  }
}
