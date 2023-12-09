import 'package:flutter/material.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/texteditor/fortune_text_viewer.dart';

class ViewPostPageArgs {
  final String json;

  ViewPostPageArgs(this.json);
}

class ViewPostPage extends StatelessWidget {
  final ViewPostPageArgs args;

  const ViewPostPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              FortuneQuillTextViewer(
                json: args.json,
              ),
              Text(
                "헬로우",
                style: FortuneTextStyle.body1Regular(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
