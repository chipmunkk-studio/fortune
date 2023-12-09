import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/di.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'bloc/missions.dart';

class MissionsTopContents extends StatelessWidget {
  const MissionsTopContents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MissionsBloc>()..add(MissionsTopInit()),
      child: const _MissionsTopContents (),
    );
  }
}

class _MissionsTopContents extends StatefulWidget {
  const _MissionsTopContents();

  @override
  State<_MissionsTopContents> createState() => _MissionsTopContentsState();
}

class _MissionsTopContentsState extends State<_MissionsTopContents> {
  final _tracker = serviceLocator<MixpanelTracker>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(FortuneTr.msgAvailableMissions, style: FortuneTextStyle.headLine2()),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            FortuneTr.msgMissionReward,
            style: FortuneTextStyle.body1Regular(color: ColorName.grey200),
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<MissionsBloc, MissionsState>(
          buildWhen: (previous, current) => previous.ad != current.ad,
          builder: (context, state) {
            final ad = state.ad;
            return ad != null
                ? Bounceable(
                    onTap: () => _tracker.trackEvent('광고_배너_클릭'),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: ColorName.grey700,
                        ),
                        width: state.ad?.size.width.toDouble(),
                        height: state.ad?.size.height.toDouble(),
                        child: AdWidget(ad: state.ad!),
                      ),
                    ),
                  )
                : Container();
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
