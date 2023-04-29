import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/date.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/main/bloc/main.dart';
import 'package:foresh_flutter/presentation/main/component/notice/top_notice_auto_slider.dart';
import 'package:transparent_image/transparent_image.dart';

class TopNotice extends StatefulWidget {
  final MainBloc _bloc;

  const TopNotice(
    this._bloc, {
    super.key,
  });

  @override
  State<TopNotice> createState() => _TopNoticeState();
}

class _TopNoticeState extends State<TopNotice> {
  final PageController pageController = PageController(initialPage: 0);
  final router = serviceLocator<FortuneRouter>().router;

  Timer timer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listenWhen: (previous, current) => previous.notices != current.notices,
      listener: (context, state) {
        _initTimer(state);
      },
      builder: (context, state) {
        return state.notices.isEmpty
            ? Container()
            : ScaleWidget(
                scaleY: 0.98,
                scaleX: 0.98,
                onTapUp: _onTap,
                child: Container(
                  height: 64.h,
                  // h를 줘서 반응형으로 적용할 시 크기가 작아짐.
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: ColorName.backgroundLight,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: TopNoticeAutoSlide(
                            widget._bloc,
                            pageController,
                            items: state.notices.map(
                              (e) {
                                return Row(
                                  children: [
                                    SizedBox(width: 12.w),
                                    SizedBox.square(
                                      dimension: 40,
                                      child: ClipOval(
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: "https://source.unsplash.com/user/max_duz/40x40",
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(text: e.nickname, style: FortuneTextStyle.body3Bold()),
                                                TextSpan(text: "님께서", style: FortuneTextStyle.body3Regular()),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: e.markerId.toString(), style: FortuneTextStyle.body3Bold()),
                                                  TextSpan(text: "를 획득하셨어요!", style: FortuneTextStyle.body3Regular()),
                                                  TextSpan(
                                                    text: "  ${FortuneDateExtension.diffTimeStamp(e.createdAt)}",
                                                    style: FortuneTextStyle.body3Regular(fontColor: ColorName.deActive)
                                                        .copyWith(
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                            duration: const Duration(seconds: 3),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 0,
                          top: 0,
                          child: Assets.icons.icArrowRight16.svg(),
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  void _initTimer(MainState state) {
    timer.cancel();
    // 페이지 index 0으로 초기화.
    int currentPage = 0;
    // 타이머 시작.
    timer = Timer.periodic(
      const Duration(milliseconds: 3000),
      (Timer timer) {
        if (pageController.hasClients) {
          if (currentPage == 0) {
            pageController.jumpToPage(currentPage);
          } else if (currentPage < state.notices.length) {
            pageController.animateToPage(
              currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
            if (currentPage == state.notices.length - 1) {
              widget._bloc.add(MainRefresh());
            }
          }
          if (currentPage < state.notices.length - 1) {
            currentPage++;
          }
        }
      },
    );
  }

  void _onTap() {
    router.navigateTo(
      context,
      Routes.markerHistoryRoute,
    );
  }
}
