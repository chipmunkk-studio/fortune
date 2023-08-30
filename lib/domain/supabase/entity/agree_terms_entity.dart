class AgreeTermsEntity {
  final int index;
  final bool isRequire;
  final String title;
  final String content;
  final bool isChecked;

  AgreeTermsEntity({
    required this.index,
    required this.isRequire,
    required this.title,
    required this.content,
    this.isChecked = false,
  });

  AgreeTermsEntity copyWith({
    int? index,
    bool? isRequire,
    String? title,
    String? content,
    bool? isChecked,
  }) {
    return AgreeTermsEntity(
      index: index ?? this.index,
      isRequire: isRequire ?? this.isRequire,
      title: title ?? this.title,
      content: content ?? this.content,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  // empty 속성 추가
  static AgreeTermsEntity get empty => AgreeTermsEntity(
        index: 0,
        isRequire: false,
        title: '',
        content: '',
        isChecked: false,
      );
}
