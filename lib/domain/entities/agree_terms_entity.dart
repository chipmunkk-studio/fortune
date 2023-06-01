class AgreeTermsEntity {
  final String title;
  final String content;
  final bool isChecked;

  AgreeTermsEntity({
    required this.title,
    required this.content,
    this.isChecked = false,
  });

  AgreeTermsEntity copyWith({
    double? index,
    bool? isRequire,
    String? title,
    String? content,
    bool? isChecked,
  }) {
    return AgreeTermsEntity(
      title: title ?? this.title,
      content: content ?? this.content,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
