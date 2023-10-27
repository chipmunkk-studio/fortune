import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/my_ingredients_view_entity.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/my_ingredients.dart';
import 'component/my_ingredients_list.dart';
import 'component/skeleton_my_ingredients.dart';
import 'component/top_area.dart';

class MyIngredientsPage extends StatelessWidget {
  const MyIngredientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MyIngredientsBloc>()..add(MyIngredientsInit()),
      child: const _MyIngredientsPage(),
    );
  }
}

class _MyIngredientsPage extends StatefulWidget {
  const _MyIngredientsPage();

  @override
  State<_MyIngredientsPage> createState() => _MyIngredientsPageState();
}

class _MyIngredientsPageState extends State<_MyIngredientsPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  final _tracker = serviceLocator<MixpanelTracker>();
  late MyIngredientsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _tracker.trackEvent('내가방_랜딩');
    _bloc = BlocProvider.of<MyIngredientsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MyIngredientsBloc, MyIngredientsSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is MyIngredientsError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<MyIngredientsBloc, MyIngredientsState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const SkeletonMyIngredients(),
            child: Column(
              children: [
                BlocBuilder<MyIngredientsBloc, MyIngredientsState>(
                  buildWhen: (previous, current) => previous.entities.totalCount != current.entities.totalCount,
                  builder: (context, state) => TopArea(count: state.entities.totalCount),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 420,
                  child: BlocBuilder<MyIngredientsBloc, MyIngredientsState>(
                    buildWhen: (previous, current) => previous.entities != current.entities,
                    builder: (context, state) => MyIngredientList(
                      entities: state.entities,
                      onTap: (selectedItem) {
                        _showIngredientDetailDialog(
                          context,
                          selectedItem,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _showIngredientDetailDialog(
    BuildContext context,
    MyIngredientsViewListEntity selectedItem,
  ) {
    final ingredient = selectedItem.ingredient;
    dialogService.showFortuneDialog(
      context,
      topContent: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: ColorName.grey700,
            ),
            child: FortuneCachedNetworkImage(
              width: 76,
              height: 76,
              imageUrl: ingredient.imageUrl,
              placeholder: Container(),
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
      title: ingredient.exposureName,
      subTitle: ingredient.desc,
      btnOkPressed: () => _tracker.trackEvent('내가방_아이템클릭'),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
    );
  }
}
