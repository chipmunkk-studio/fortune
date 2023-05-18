class FaqEntity {
  final List<FaqContentEntity> faqs;

  FaqEntity({required this.faqs});
}

abstract class FaqContentParentEntity {}

class FaqContentEntity extends FaqContentParentEntity {
  final String title;
  final String content;
  final String createdAt;

  FaqContentEntity({
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

class FaqContentNextPageLoading extends FaqContentParentEntity {

}

