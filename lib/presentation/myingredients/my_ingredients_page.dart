import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/my_ingredients_view_entity.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:transparent_image/transparent_image.dart';

import 'bloc/my_ingredients.dart';
import 'component/my_ingredients_list.dart';
import 'component/skeleton_my_ingredients.dart';
import 'component/top_area.dart';

class MyIngredientsPage extends StatelessWidget {
  const MyIngredientsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MyIngredientsBloc>()..add(MyIngredientsInit()),
      child: const _MyIngredientsPage(),
    );
  }
}

class _MyIngredientsPage extends StatefulWidget {
  const _MyIngredientsPage({Key? key}) : super(key: key);

  @override
  State<_MyIngredientsPage> createState() => _MyIngredientsPageState();
}

class _MyIngredientsPageState extends State<_MyIngredientsPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  late MyIngredientsBloc _bloc;

  @override
  void initState() {
    super.initState();
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
                        // todo
                        // _showIngredientDetailDialog(
                        //   context,
                        //   selectedItem,
                        // );
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
    final histories = selectedItem.histories;
    final recentObtainHistory = histories.isNotEmpty ? histories[0] : null;
    final recentDate = recentObtainHistory != null
        ? FortuneDateExtension.formattedDate(recentObtainHistory.createdAt, format: 'yyyy년 MM월 dd일 hh시 mm분')
        : '재료 획득 이력이 없음';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            // 여기를 추가
            borderRadius: BorderRadius.circular(20.0), // 원하는 반경 값
          ),
          backgroundColor: ColorName.grey600,
          insetPadding: const EdgeInsets.all(10),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            direction: Axis.vertical,
            children: [
              FadeInImage.memoryNetwork(
                width: 200,
                height: 200,
                placeholder: kTransparentImage,
                image: selectedItem.ingredient.imageUrl,
              ),
              Text(
                "${selectedItem.ingredient.type}",
                style: FortuneTextStyle.body3Light(),
              ),
              Text(
                selectedItem.ingredient.exposureName,
                style: FortuneTextStyle.body3Light(),
              ),
              Text(
                recentDate,
                style: FortuneTextStyle.body3Light(),
              ),
            ],
          ),
        );
      },
    );
  }
}
