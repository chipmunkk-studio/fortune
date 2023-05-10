import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';

class FortuneHistoryPage extends StatelessWidget {
  const FortuneHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "포춘 이용내역"),
      child: const _FortuneHistoryPage(),
    );
  }
}

class _FortuneHistoryPage extends StatefulWidget {
  const _FortuneHistoryPage({Key? key}) : super(key: key);

  @override
  State<_FortuneHistoryPage> createState() => _FortuneHistoryPageState();
}

class _FortuneHistoryPageState extends State<_FortuneHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
