// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fortune/core/gen/assets.gen.dart';
// import 'package:fortune/core/gen/colors.gen.dart';
// import 'package:fortune/core/message_ext.dart';
// import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
//
// import '../../../../core/util/textstyle.dart';
// import '../../bloc/mission_detail.dart';
//
// class GradeMission extends StatelessWidget {
//   final MissionDetailState state;
//   final Function0 onExchangeClick;
//
//   const GradeMission(
//     this.state, {
//     super.key,
//     required this.onExchangeClick,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Stack(
//             children: [
//               ListView(
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       state.entity.mission.title,
//                       style: FortuneTextStyle.headLine2(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       state.entity.mission.content,
//                       style: FortuneTextStyle.body1Regular(
//                         color: ColorName.grey200,
//                         height: 1.3,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   BlocBuilder<MissionDetailBloc, MissionDetailState>(
//                     buildWhen: (previous, current) => previous.isFortuneCookieOpen != current.isFortuneCookieOpen,
//                     builder: (context, state) {
//                       return state.isFortuneCookieOpen
//                           ? Assets.icons.icFortuneCookie2.svg()
//                           : Assets.icons.icFortuneCookie1.svg();
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
//                     child: BlocBuilder<MissionDetailBloc, MissionDetailState>(
//                       buildWhen: (previous, current) => previous.isEnableButton != current.isEnableButton,
//                       builder: (context, state) {
//                         return FortuneScaleButton(
//                           isEnabled: state.isEnableButton,
//                           text: FortuneTr.msgExchange,
//                           onPress: onExchangeClick,
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   const Divider(height: 16, thickness: 16, color: ColorName.grey800),
//                   const SizedBox(height: 24),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(FortuneTr.msgMissionGuide, style: FortuneTextStyle.body2Semibold()),
//                   ),
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       state.entity.mission.note,
//                       style: FortuneTextStyle.body3Regular(color: ColorName.grey200, height: 1.4),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(FortuneTr.msgRewardGuide, style: FortuneTextStyle.body2Semibold()),
//                   ),
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       state.entity.mission.reward.note,
//                       style: FortuneTextStyle.body3Regular(color: ColorName.grey200, height: 1.4),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(FortuneTr.msgCaution, style: FortuneTextStyle.body2Semibold()),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildCaution(),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 20,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         ColorName.grey900.withOpacity(1.0),
//                         ColorName.grey900.withOpacity(0.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // 주의 사항.
//   Padding _buildCaution() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             FortuneTr.msgMissionEarlyEnd,
//             style: FortuneTextStyle.body3Regular(color: ColorName.grey200, height: 1.4),
//           ),
//           Text(
//             FortuneTr.msgUnfairParticipation,
//             style: FortuneTextStyle.body3Regular(color: ColorName.grey200, height: 1.4),
//           ),
//         ],
//       ),
//     );
//   }
// }
