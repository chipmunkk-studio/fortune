import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/widgets/button/fortune_text_button.dart';
import 'package:fortune/core/widgets/texteditor/fortune_text_editor.dart';
import 'package:fortune/di.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/write_post.dart';

class WritePostPage extends StatelessWidget {
  const WritePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<WritePostBloc>()..add(WritePostInit()),
      child: const _WritePostPage(),
    );
  }
}

class _WritePostPage extends StatefulWidget {
  const _WritePostPage();

  @override
  State<_WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<_WritePostPage> {
  late WritePostBloc _bloc;
  final QuillController _inputController = QuillController.basic();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<WritePostBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<WritePostBloc, WritePostSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is WritePostError) {
          // dialogService.showWebErrorDialog(context, sideEffect.error);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              // Expanded(
              //   child: FortuneQuillTextEditor(
              //     controller: _inputController,
              //   ),
              // ),
              FortuneTextButton(
                onPress: () {
                  _bloc.add(
                    WritePostRequest(
                      jsonEncode(_inputController.document.toDelta().toJson()),
                    ),
                  );
                  // _appRouter.navigateTo(
                  //   context,
                  //   AppRoutes.viewPostRoutes,
                  //   routeSettings: RouteSettings(
                  //     arguments: ViewPostPageArgs(
                  //       jsonEncode(_inputController.document.toDelta().toJson()),
                  //     ),
                  //   ),
                  // );
                },
                text: '글보기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
