import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';

class TicketHistoryPage extends StatelessWidget {
  const TicketHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "티켓 이용 내역"),
      child: const _TicketHistoryPage(),
    );
  }
}

class _TicketHistoryPage extends StatefulWidget {
  const _TicketHistoryPage({Key? key}) : super(key: key);

  @override
  State<_TicketHistoryPage> createState() => _TicketHistoryPageState();
}

class _TicketHistoryPageState extends State<_TicketHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
