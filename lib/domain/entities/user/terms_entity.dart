class TermsEntity {
  final List<Term> terms;

  TermsEntity({
    required this.terms,
  });
}

class Term {
  final String? title;
  final String? content;

  Term({
    this.title,
    this.content,
  });
}
