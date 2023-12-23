import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/util/toast.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/main/bloc/main.dart';
import 'package:lottie/lottie.dart';

class RandomBoxWidget extends StatefulWidget {
  final int timerSecond;
  final bool isOpenable;
  final MainBloc mainBloc;

  final GiftboxType type;

  const RandomBoxWidget(
    this.mainBloc, {
    super.key,
    required this.timerSecond,
    required this.isOpenable,
    required this.type,
  });

  @override
  State<RandomBoxWidget> createState() => _RandomBoxWidgetState();
}

class _RandomBoxWidgetState extends State<RandomBoxWidget> {
  final FToast _fToast = FToast();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: ColorName.grey700,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _getIcon(widget.type),
                  Positioned(
                    bottom: -6,
                    left: 0,
                    right: 0,
                    child: Text(
                      widget.isOpenable ? "Open" : _formatSeconds(widget.timerSecond),
                      textAlign: TextAlign.center,
                      style: FortuneTextStyle.caption3Semibold(
                        color: ColorName.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _getTitle(widget.type),
              style: FortuneTextStyle.caption1SemiBold(),
            ),
          ],
        ),
      ),
    );
  }

  _handleTap() {
    if (widget.isOpenable) {
      widget.mainBloc.add(MainOpenRandomBox(widget.type));
    } else {
      _fToast.showToast(
        child: fortuneToastContent(
          icon: Assets.icons.icInfo.svg(),
          content: FortuneTr.msgRequireMoreTime,
        ),
        positionedToastBuilder: (context, child) => Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: child,
        ),
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  String _formatSeconds(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(seconds ~/ 60);
    final remainingSeconds = twoDigits(seconds % 60);
    return "$minutes:$remainingSeconds";
  }

  _getIcon(GiftboxType type) {
    if (widget.type == GiftboxType.coin) {
      return Assets.icons.icCoinPocket.svg(width: 32, height: 32);
    } else {
      return Assets.icons.icRandomBox.svg(width: 32, height: 32);
    }
  }

  _getTitle(GiftboxType type) {
    if (widget.type == GiftboxType.coin) {
      return FortuneTr.msgCoinPick;
    } else {
      return FortuneTr.msgGiftBox;
    }
  }
}
