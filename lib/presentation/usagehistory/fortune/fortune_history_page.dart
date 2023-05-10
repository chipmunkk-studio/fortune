import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:skeletons/skeletons.dart';

class FortuneHistoryPage extends StatelessWidget {
  const FortuneHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "포춘 이용내역"),
      child: const _FortuneHistoryPage(),
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
      skeleton: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 96.h,
              width: 350.w,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: ColorName.backgroundLight,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("보유한 포춘", style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark)),
                SizedBox(height: 8.h),
                Text("1,234개", style: FortuneTextStyle.subTitle3Bold())
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              Chip(
                labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                backgroundColor: Colors.white,
                label: Text('전체', style: FortuneTextStyle.body2SemiBold(fontColor: Colors.black)),
              ),
              Chip(
                label: Text('획득', style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.activeDark)),
                labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  side: const BorderSide(
                    color: ColorName.deActiveDark,
                    width: 1.0,
                  ),
                ),
                backgroundColor: ColorName.background,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              Chip(
                label: Text('사용', style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.activeDark)),
                labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  side: const BorderSide(
                    color: ColorName.deActiveDark,
                    width: 1.0,
                  ),
                ),
                backgroundColor: ColorName.background,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ],
          )
        ],
      ),
    );
  }
}
