import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/painter/squircle_painter.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/main/bloc/main.dart';
import 'package:fortune/presentation/main/component/notice/top_notice_auto_slider.dart';

class TopNotice extends StatefulWidget {
  final dartz.Function0 onTap;

  const TopNotice({
    super.key,
    required this.onTap,
  });

  @override
  State<TopNotice> createState() => _TopNoticeState();
}

class _TopNoticeState extends State<TopNotice> {
  final PageController pageController = PageController(initialPage: 0);
  final router = serviceLocator<FortuneAppRouter>().router;

  Timer timer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listenWhen: (previous, current) => previous.missionClearUsers != current.missionClearUsers,
      listener: (context, state) {
        _initTimer(state);
      },
      builder: (context, state) {
        return state.missionClearUsers.isEmpty
            ? _buildEmptyContainer()
            : Bounceable(
                onTap: widget.onTap,
                child: Container(
                  height: 68,
                  // h를 줘서 반응형으로 적용할 시 크기가 작아짐.
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: ColorName.grey700,
                  ),
                  child: TopNoticeAutoSlide(
                    pageController,
                    items: state.missionClearUsers.map(
                      (e) {
                        return Row(
                          children: [
                            const SizedBox(width: 12),
                            FortuneCachedNetworkImage(
                              width: 44.h,
                              height: 44.h,
                              imageUrl: e.user.profileImage,
                              errorWidget: Container(
                                decoration: BoxDecoration(
                                  color: ColorName.grey700,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorName.grey700,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.h),
                                  child: Assets.images.ivDefaultProfile.svg(),
                                ),
                              ),
                              imageShape: ImageShape.circle,
                              placeholder: Container(),
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        e.createdAt,
                                        style: FortuneTextStyle.body2Regular(),
                                      ),
                                      const SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          e.user.nickname.isEmpty ? FortuneTr.msgUnknownUser : e.user.nickname,
                                          style: FortuneTextStyle.body2Semibold(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        FortuneTr.msgHelpedBy,
                                        style: FortuneTextStyle.body2Regular(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Flexible(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            e.mission.title,
                                            style: FortuneTextStyle.body2Regular(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          " ${FortuneTr.msgAcquired}",
                                          style: FortuneTextStyle.body2Regular(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        );
                      },
                    ).toList(),
                    duration: const Duration(seconds: 3),
                  ),
                ),
              );
      },
    );
  }

  _buildEmptyContainer() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: ColorName.grey700,
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          CustomPaint(
            painter: SquirclePainter(color: ColorName.grey600),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox.square(
                dimension: 20,
                child: Assets.icons.icLogo20.svg(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  FortuneTr.msgNoMissionCompletion,
                  style: FortuneTextStyle.body3Regular(height: 1.3),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
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
          } else if (currentPage < state.missionClearUsers.length) {
            pageController.animateToPage(
              currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
            if (currentPage == state.missionClearUsers.length - 1) {
              // widget._bloc.add(MainRefresh());
            }
          }
          if (currentPage < state.missionClearUsers.length - 1) {
            currentPage++;
          }
        }
      },
    );
  }
}
