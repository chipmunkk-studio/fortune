import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/my_missions.dart';
import 'component/item_my_mission_reward.dart';
import 'component/top_area.dart';

class MyMissionsPage extends StatelessWidget {
  const MyMissionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MyMissionsBloc>()..add(MyMissionsInit()),
      child: FortuneScaffold(
        padding: EdgeInsets.zero,
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: FortuneTr.msgMissionHistory),
        child: const _MyMissionsPage(),
      ),
    );
  }
}

class _MyMissionsPage extends StatefulWidget {
  const _MyMissionsPage({Key? key}) : super(key: key);

  @override
  State<_MyMissionsPage> createState() => _MyMissionsPageState();
}

class _MyMissionsPageState extends State<_MyMissionsPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  late MyMissionsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MyMissionsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MyMissionsBloc, MyMissionsSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is MyMissionsError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<MyMissionsBloc, MyMissionsState>(
        builder: (context, state) {
          final count = state.missions.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopArea(count: state.missions.length),
              const SizedBox(height: 20),
              Expanded(
                child: state.missions.isNotEmpty
                    ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.missions.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        separatorBuilder: (context, index) => const Divider(
                          height: 40,
                          color: ColorName.grey800,
                        ),
                        itemBuilder: (context, index) {
                          final item = state.missions[index];
                          return ItemMyMissionReward(item: item);
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Center(
                          child: Text(
                            FortuneTr.msgNoCompletedMissions,
                            style: FortuneTextStyle.body1Light(color: ColorName.grey200),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
