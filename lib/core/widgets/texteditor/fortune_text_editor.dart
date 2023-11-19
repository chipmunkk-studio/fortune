import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/gen/fonts.gen.dart';
import 'package:fortune/core/util/textstyle.dart';

import 'fortune_text_editor_style.dart';

class FortuneQuillTextEditor extends StatelessWidget {
  const FortuneQuillTextEditor({
    super.key,
    required QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

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
    return QuillProvider(
      configurations: QuillConfigurations(
        controller: _controller,
        sharedConfigurations: QuillSharedConfigurations(
          locale: Locale(Localizations.localeOf(context).languageCode),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                expands: true,
                readOnly: false,
                autoFocus: true,
                padding: const EdgeInsets.symmetric(vertical: 16),
                placeholder: '입력해주세요..',
                embedBuilders: kIsWeb ? FlutterQuillEmbeds.editorWebBuilders() : FlutterQuillEmbeds.editorBuilders(),
                customStyles: buildDefaultStyles(
                  defaultTextStyle,
                  baseStyle,
                  inlineCodeStyle,
                  baseSpacing,
                ),
              ),
            ),
          ),
          QuillToolbar(
            configurations: QuillToolbarConfigurations(
              showAlignmentButtons: true,
              multiRowsDisplay: false,
              embedButtons: FlutterQuillEmbeds.toolbarButtons(
                videoButtonOptions: null,
                imageButtonOptions: QuillToolbarImageButtonOptions(
                  fillColor: ColorName.white,
                  dialogTheme: QuillDialogTheme(
                    labelTextStyle: FortuneTextStyle.body1Light(),
                    buttonTextStyle: FortuneTextStyle.body1Light(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
