// class _Skeleton extends StatelessWidget {
//   const _Skeleton({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(width: 20.w),
//             const SkeletonAvatar(
//               style: SkeletonAvatarStyle(
//                 shape: BoxShape.circle,
//                 width: 70,
//                 height: 70,
//               ),
//             ),
//             SizedBox(width: 20.w),
//             Expanded(
//               child: SkeletonParagraph(
//                 style: SkeletonParagraphStyle(
//                   lines: 2,
//                   spacing: 12,
//                   lineStyle: SkeletonLineStyle(
//                     randomLength: false,
//                     height: 20,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 42.w),
//           ],
//         ),
//         SizedBox(height: 36.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Flexible(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(width: 24.w),
//                   Flexible(
//                     child: SkeletonLine(
//                       style: SkeletonLineStyle(
//                         height: 20,
//                         width: 128,
//                         borderRadius: BorderRadius.circular(16.r),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 9.w),
//                   SkeletonLine(
//                     style: SkeletonLineStyle(
//                       height: 20,
//                       width: 96,
//                       borderRadius: BorderRadius.circular(16.r),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 24.w),
//           ],
//         ),
//       ],
//     );
//   }
// }