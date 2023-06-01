class TermsEntity {
  final List<Term> terms;

  TermsEntity({
    required this.terms,
  });
}

class Term {
  final String title;
  final String content;

  Term({
    required this.title,
    required this.content,
  });
}
