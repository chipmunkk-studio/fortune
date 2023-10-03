class PrivacyPolicyEntity {
  final String title;
  final String content;
  final String createdAt;

  PrivacyPolicyEntity({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  PrivacyPolicyEntity copyWith({
    String? title,
    String? content,
    String? createdAt,
  }) {
    return PrivacyPolicyEntity(
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // empty 속성 추가
  static PrivacyPolicyEntity get empty => PrivacyPolicyEntity(
        title: '',
        content: '',
        createdAt: '',
      );
}
