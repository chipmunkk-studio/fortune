import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/domain/entities/fortune_history_entity.dart';
import 'package:foresh_flutter/presentation/usagehistory/component/bottom_history_list.dart';
import 'package:foresh_flutter/presentation/usagehistory/component/middle_filter.dart';
import 'package:foresh_flutter/presentation/usagehistory/component/top_have_count.dart';
import 'package:skeletons/skeletons.dart';

class FortuneHistoryPage extends StatelessWidget {
  const FortuneHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "포춘 이용내역"),
      body: const _FortuneHistoryPage(),
    );
  }
}

class _FortuneHistoryPage extends StatefulWidget {
  const _FortuneHistoryPage({Key? key}) : super(key: key);

  @override
  State<_FortuneHistoryPage> createState() => _FortuneHistoryPageState();
}

class _FortuneHistoryPageState extends State<_FortuneHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: false,
      skeleton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 96,
                width: 350,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            const SizedBox(height: 39),
            Row(
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 64,
                    width: 256,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TopHaveCount(fortuneCount: "1,234개"),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MiddleFilter(
                  onFilterTap: (filter) {},
                ),
              ),
              Expanded(
                child: BottomHistoryList(
                  items: testItems,
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //   child: Column(
          //     children: [
          //       SkeletonLine(
          //         style: SkeletonLineStyle(
          //           height: 96,
          //           width: 350,
          //           borderRadius: BorderRadius.circular(16.r),
          //         ),
          //       ),
          //       SizedBox(height: 39),
          //       Row(
          //         children: [
          //           SkeletonLine(
          //             style: SkeletonLineStyle(
          //               height: 68,
          //               width: 256,
          //               borderRadius: BorderRadius.circular(16.r),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

final testItems = [
  FortuneUsageHistoryEntity(
    date: "2023년 5월 15일",
    items: [
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
    ],
  ),
  FortuneUsageHistoryEntity(
    date: "2023년 5월 14일",
    items: [
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
    ],
  ),
  FortuneUsageHistoryEntity(
    date: "2023년 5월 13일",
    items: [
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
    ],
  ),
  FortuneUsageHistoryEntity(
    date: "2023년 5월 12일",
    items: [
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
    ],
  ),
  FortuneUsageHistoryEntity(
    date: "2023년 5월 11일",
    items: [
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
    ],
  ),
  FortuneUsageHistoryEntity(
    date: "2023년 5월 3일",
    items: [
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 1", time: "12:30:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 3", time: "12:34:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 4", time: "12:36:59"),
      FortuneUsageHistoryItemEntity(content: "레이더 구매 시 금화 사용 2", time: "12:32:59"),
    ],
  )
];
