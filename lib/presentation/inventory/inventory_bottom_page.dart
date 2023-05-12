import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/inventory/bloc/inventory.dart';
import 'package:foresh_flutter/presentation/inventory/component/profile.dart';
import 'package:foresh_flutter/presentation/inventory/component/stamp_exchange.dart';
import 'package:foresh_flutter/presentation/inventory/component/stamps.dart';
import 'package:foresh_flutter/presentation/inventory/component/stamps_skeleton.dart';
import 'package:skeletons/skeletons.dart';

class InventoryBottomPage extends StatelessWidget {
  const InventoryBottomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<InventoryBloc>()..add(InventoryInit()),
      child: const _InventoryBottomPage(),
    );
  }
}

class _InventoryBottomPage extends StatefulWidget {
  const _InventoryBottomPage();

  @override
  State<_InventoryBottomPage> createState() => _InventoryBottomPageState();
}

class _InventoryBottomPageState extends State<_InventoryBottomPage> {
  final router = serviceLocator<FortuneRouter>().router;

  late final InventoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<InventoryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return !state.isLoading
            ? Column(
                children: [
                  BlocBuilder<InventoryBloc, InventoryState>(
                    buildWhen: (previous, current) =>
                        previous.nickname != current.nickname || previous.profileImage != current.profileImage,
                    builder: (context, state) {
                      return Profile(
                        profile: state.profileImage,
                        nickname: state.nickname,
                        onNicknameClick: () => router.navigateTo(context, Routes.myPageRoute),
                        onGradeClick: () => router.navigateTo(context, Routes.gradeGuideRoute),
                      );
                    },
                  ),
                  SizedBox(height: 36.h),
                  StampExchange(
                    onStampExchangeClick: () => _navigateToExchangePage(context),
                  ),
                  SizedBox(height: 33.h),
                  BlocBuilder<InventoryBloc, InventoryState>(
                    buildWhen: (previous, current) => previous.markers != current.markers,
                    builder: (context, state) {
                      return state.markers.isNotEmpty
                          ? MarkerStamps(
                              stamps: state.markers,
                              onStampClick: () => _navigateToExchangePage(context),
                            )
                          : const MarkerStampsSkeleton(
                              top: [0, 1],
                              center: [2, 3, 4],
                              bottom: [5, 6],
                            );
                    },
                  )
                ],
              )
            : Center(
                child: SizedBox.square(
                  dimension: 32.w,
                  child: const CircularProgressIndicator(
                    color: ColorName.secondary,
                  ),
                ),
              );
      },
    );
  }

  _navigateToExchangePage(BuildContext context) {
    router.navigateTo(
      context,
      Routes.rewardListRoute,
    );
  }
}
