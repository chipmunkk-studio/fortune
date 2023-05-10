import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "공지사항"),
      child: const _AnnouncementPage(),
    );
  }
}

class _AnnouncementPage extends StatefulWidget {
  const _AnnouncementPage({Key? key}) : super(key: key);

  @override
  State<_AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<_AnnouncementPage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "공지사항",
        style: FortuneTextStyle.headLine1(),
      ),
    );
  }
}
