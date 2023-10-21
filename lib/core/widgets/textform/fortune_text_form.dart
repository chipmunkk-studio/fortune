import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/suffixicon/default_prefix_icon.dart';
import 'package:fortune/core/widgets/suffixicon/default_suffix_icon.dart';

class FortuneTextForm extends StatefulWidget {
  final dartz.Function1<String, void> onTextChanged;
  final String? suffixIcon;
  final String? prefixIcon;
  final dartz.Function0? onSuffixIconClicked;
  final dartz.Function0? onPrefixIconClicked;
  final TextInputType? keyboardType;
  final bool autoFocus;
  final String? hint;
  final Color? textColor;
  final bool readOnly;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final int? maxLength;

  const FortuneTextForm({
    required this.onTextChanged,
    required this.textEditingController,
    this.errorText,
    Key? key,
    this.keyboardType,
    this.hint,
    this.maxLength,
    this.textColor,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onSuffixIconClicked,
    this.onPrefixIconClicked,
    this.inputFormatters,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  State<FortuneTextForm> createState() => _FortuneTextFormState();
}

class _FortuneTextFormState extends State<FortuneTextForm> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    widget.textEditingController?.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var suffixIcon = widget.suffixIcon != null
        ? DefaultSuffixIcon(
            svgIcon: widget.suffixIcon,
            press: widget.onSuffixIconClicked,
          )
        : null;
    var prefixIcon = widget.prefixIcon != null
        ? DefaultPrefixIcon(
            svgIcon: widget.suffixIcon,
            press: widget.onPrefixIconClicked,
          )
        : null;
    return TextFormField(
      autofocus: widget.autoFocus,
      focusNode: focusNode,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      style: FortuneTextStyle.button1Medium(fontColor: widget.textColor),
      controller: widget.textEditingController,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: (value) => widget.onTextChanged(value),
      decoration: InputDecoration(
        isDense: false,
        hintText: widget.hint,
        contentPadding: EdgeInsets.fromLTRB(prefixIcon == null ? 16 : 0, 16, suffixIcon == null ? 16 : 0, 16),
        counterText: "",
        hintStyle: FortuneTextStyle.subTitle2Medium(color: ColorName.grey500),
        errorText: widget.errorText,
        errorStyle: FortuneTextStyle.body3Light(color: ColorName.negative),
        suffixIcon: focusNode.hasFocus ? suffixIcon : null,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
