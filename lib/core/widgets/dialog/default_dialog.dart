import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

extension FortuneDialogEx on BuildContext {
  void showFortuneDialog({
    required String title,
    String? subTitle,
    String? btnOkText,
    Function0? btnOkPressed,
    String? btnCancelText,
    Function0? btnCancelPressed,
    dismissOnTouchOutside = false,
    dismissOnBackKeyPress = false,
  }) {
    AwesomeDialog(
      context: this,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      dialogBackgroundColor: ColorName.grey800,
      buttonsTextStyle: FortuneTextStyle.button1Medium(fontColor: ColorName.grey800),
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  title,
                  style: FortuneTextStyle.headLine2(),
                  textAlign: TextAlign.center,
                ),
                if (subTitle != null) const SizedBox(height: 12),
                if (subTitle != null)
                  Text(
                    subTitle,
                    style: FortuneTextStyle.body1Light(fontColor: ColorName.grey200),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 10),
      dialogBorderRadius: BorderRadius.circular(
        32.r,
      ),
      btnOkColor: ColorName.primary,
      btnCancelColor: ColorName.grey700,
      btnCancelText: btnCancelText,
      btnCancelOnPress: btnCancelPressed,
      btnOkText: btnOkText,
      btnOkOnPress: btnOkPressed,
    ).show();
  }

  void showFortuneMaterialDialog({
    required String title,
    required String message,
    required String buttonText,
    required Function0 onPressed,
    LottieBuilder? lottieBuilder,
  }) =>
      Dialogs.materialDialog(
        color: Colors.white,
        msg: message,
        title: title,
        barrierDismissible: false,
        lottieBuilder: lottieBuilder,
        barrierColor: Colors.black12.withOpacity(0.6),
        // Background color
        dialogWidth: kIsWeb ? 0.3 : null,
        context: this,
        actions: [
          SizedBox(
            height: 46,
            child: IconsButton(
              onPressed: onPressed,
              text: buttonText,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.amberAccent,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ),
        ],
      );
}
