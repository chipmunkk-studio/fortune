import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "자주 묻는 질문"),
      child: const _QuestionPage(),
    );
  }
}

class _QuestionPage extends StatefulWidget {
  const _QuestionPage({Key? key}) : super(key: key);

  @override
  State<_QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<_QuestionPage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "자주 묻는 질문",
        style: FortuneTextStyle.headLine1(),
      ),
    );
  }
}
