import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';

class AdLoadingView extends StatelessWidget {
  const AdLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(
        context,
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.h),
          child: Text(
            FortuneTr.msgAdPlaying,
            style: FortuneTextStyle.body1Light(height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
