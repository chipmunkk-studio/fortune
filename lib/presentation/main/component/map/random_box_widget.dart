import 'dart:async';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/main/bloc/main.dart';
import 'package:lottie/lottie.dart';

class RandomBoxWidget extends StatefulWidget {
  final int randomBoxTimerSecond;
  final bool isOpenable;
  final MainBloc mainBloc;

  const RandomBoxWidget(
    this.mainBloc, {
    super.key,
    required this.randomBoxTimerSecond,
    required this.isOpenable,
  });

  @override
  State<RandomBoxWidget> createState() => _RandomBoxWidgetState();
}

class _RandomBoxWidgetState extends State<RandomBoxWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isOpenable ? () => widget.mainBloc.add(MainOpenRandomBox(GiftboxType.random)) : null,
      child: Align(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            DotLottieLoader.fromAsset(
              Assets.lottie.randomMarkerBox,
              frameBuilder: (ctx, dotlottie) {
                return dotlottie != null
                    ? Lottie.memory(
                        dotlottie.animations.values.single,
                        width: 64,
                        height: 64,
                      )
                    : Container();
              },
              errorBuilder: (ctx, e, s) => Container(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.9,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: widget.isOpenable
                            ? ColorName.secondary.withOpacity(0.7)
                            : ColorName.primary.withOpacity(0.3)),
                    child: Text(
                      widget.isOpenable ? FortuneTr.msgOpenGiftBox : _formatSeconds(widget.randomBoxTimerSecond),
                      style: FortuneTextStyle.caption3Semibold(
                        color: ColorName.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(seconds ~/ 60);
    final remainingSeconds = twoDigits(seconds % 60);
    return "$minutes:$remainingSeconds";
  }
}
