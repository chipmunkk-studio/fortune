import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class StorePage extends StatelessWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "스토어"),
      child: const _StorePage(),
    );
  }
}

class _StorePage extends StatefulWidget {
  const _StorePage({Key? key}) : super(key: key);

  @override
  State<_StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<_StorePage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "스토어",
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
