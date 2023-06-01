import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_card_entity.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class MissionCardList extends StatelessWidget {
  final dartz.Function1<int, void> onItemClick;
  final List<MissionCardEntity> missions;

  const MissionCardList({
    required this.missions,
    required this.onItemClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: missions.length,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        final item = missions[index];
        return Bounceable(
          onTap: () => onItemClick(item.id),
          child: _MissionItem(item),
        );
      },
    );
  }
}

class _MissionItem extends StatelessWidget {
  const _MissionItem(this.mission);

  final MissionCardEntity mission;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            color: ColorName.backgroundLight,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: FortuneTextStyle.subTitle3Bold(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "카페 마커 300개 수집하기",
                      style: FortuneTextStyle.body2Regular(
                        fontColor: ColorName.activeDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            color: ColorName.primary.withOpacity(0.1),
                          ),
                          child: Text(
                            "남은 리워드",
                            style: FortuneTextStyle.caption1SemiBold(
                              fontColor: ColorName.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${mission.remainedStock}",
                                style: FortuneTextStyle.body3Regular(fontColor: Colors.white),
                              ),
                              TextSpan(
                                text: "/${mission.stock}",
                                style: FortuneTextStyle.body3Regular(fontColor: ColorName.deActiveDark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox.square(
                dimension: 96,
                child: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: mission.imageUrl,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorName.deActiveDark,
                width: 0.5,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              color: ColorName.deActiveDark.withOpacity(0.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 12,
                    animationDuration: 2000,
                    percent: mission.userHaveMarkerCount / mission.targetMarkerCount,
                    padding: const EdgeInsets.all(0),
                    barRadius: Radius.circular(16.r),
                    backgroundColor: ColorName.deActiveDark.withOpacity(0.3),
                    progressColor: ColorName.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${mission.userHaveMarkerCount}",
                        style: FortuneTextStyle.body3Regular(fontColor: ColorName.secondary),
                      ),
                      TextSpan(
                        text: "/${mission.targetMarkerCount}",
                        style: FortuneTextStyle.body3Regular(fontColor: ColorName.deActiveDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
