import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/my_ingredients.dart';

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
  final _router = serviceLocator<FortuneRouter>().router;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<MyIngredientsBloc, MyIngredientsState>(
            buildWhen: (previous, current) => previous.entities.totalCount != current.entities.totalCount,
            builder: (context, state) {
              return Row(
                children: [
                  const SizedBox(width: 24),
                  Text(
                    "내 가방",
                    style: FortuneTextStyle.headLine2(),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: ColorName.primary.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      '${state.entities.totalCount}개',
                      style: FortuneTextStyle.caption1SemiBold(fontColor: ColorName.primary),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
