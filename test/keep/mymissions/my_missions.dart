// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fortune/core/navigation/fortune_app_router.dart';
// import 'package:fortune/core/widgets/fortune_scaffold.dart';
// import 'package:fortune/di.dart';
// import 'package:side_effect_bloc/side_effect_bloc.dart';
//
// import 'bloc/my_missions.dart';
//
// class MyMissionsPage extends StatelessWidget {
//   const MyMissionsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => serviceLocator<MyMissionsBloc>()..add(MyMissionsInit()),
//       child: FortuneScaffold(
//         appBar: FortuneCustomAppBar.leadingAppBar(context, title: ''),
//         child: const _MyMissionsPage(),
//       ),
//     );
//   }
// }
//
// class _MyMissionsPage extends StatefulWidget {
//   const _MyMissionsPage({Key? key}) : super(key: key);
//
//   @override
//   State<_MyMissionsPage> createState() => _MyMissionsPageState();
// }
//
// class _MyMissionsPageState extends State<_MyMissionsPage> {
//   final _router = serviceLocator<FortuneAppRouter>().router;
//   late MyMissionsBloc _bloc;
//
//   @override
//   void initState() {
//     super.initState();
//     _bloc = BlocProvider.of<MyMissionsBloc>(context);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _bloc.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocSideEffectListener<MyMissionsBloc, MyMissionsSideEffect>(
//       listener: (context, sideEffect) async {
//         if (sideEffect is MyMissionsError) {
//           dialogService.showErrorDialog(context, sideEffect.error);
//         }
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [],
//       ),
//     );
//   }
// }
