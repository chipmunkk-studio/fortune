import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/gen/fonts.gen.dart';

import 'fortune_text_editor_style.dart';

class FortuneQuillTextViewer extends StatelessWidget {
  FortuneQuillTextViewer({
    super.key,
    required this.json,
  });

  final QuillController _controller = QuillController.basic();
  final String json;

  @override
  Widget build(BuildContext context) {
    DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle baseStyle = defaultTextStyle.style.copyWith(
      fontSize: 16,
      height: 1.3,
      fontFamily: FontFamily.pretendardRegular,
      color: ColorName.white,
      decoration: TextDecoration.none,
    );
    TextStyle inlineCodeStyle = TextStyle(
      fontSize: 14,
      color: ColorName.grey900.withOpacity(0.8),
      fontFamily: FontFamily.pretendardRegular,
    );
    const baseSpacing = VerticalSpacing(6, 0);
    _controller.document = Document.fromJson(jsonDecode(json));
    return QuillProvider(
      configurations: QuillConfigurations(
        controller: _controller,
        sharedConfigurations: QuillSharedConfigurations(
          locale: Locale(Localizations.localeOf(context).languageCode),
        ),
      ),
      child: QuillEditor.basic(
        configurations: QuillEditorConfigurations(
          expands: false,
          readOnly: true,
          showCursor: false,
          embedBuilders: kIsWeb ? FlutterQuillEmbeds.editorWebBuilders() : FlutterQuillEmbeds.editorBuilders(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          customStyles: buildDefaultStyles(
            defaultTextStyle,
            baseStyle,
            inlineCodeStyle,
            baseSpacing,
          ),
        ),
      ),
    );
  }
}
