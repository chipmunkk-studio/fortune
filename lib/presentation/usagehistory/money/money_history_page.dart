import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';

class MoneyHistoryPage extends StatelessWidget {
  const MoneyHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "금화 이용내역"),
      child: const _MoneyHistoryPage(),
    );
  }
}

class _MoneyHistoryPage extends StatefulWidget {
  const _MoneyHistoryPage({Key? key}) : super(key: key);

  @override
  State<_MoneyHistoryPage> createState() => _MoneyHistoryPageState();
}

class _MoneyHistoryPageState extends State<_MoneyHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
