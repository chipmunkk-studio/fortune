import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "마이페이지"),
      child: const _MyPage(),
    );
  }
}

class _MyPage extends StatefulWidget {
  const _MyPage({Key? key}) : super(key: key);

  @override
  State<_MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<_MyPage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "마이페이지",
        style: FortuneTextStyle.headLine1(),
      ),
    );
  }

  _onPop(String code, String name) {
    router.pop(
      context,
      true,
    );
  }
}
