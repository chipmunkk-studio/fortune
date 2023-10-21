// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:side_effect_bloc/side_effect_bloc.dart';
//
// import 'my_missions.dart';
//
// class MyMissionsBloc extends Bloc<MyMissionsEvent, MyMissionsState>
//     with SideEffectBlocMixin<MyMissionsEvent, MyMissionsState, MyMissionsSideEffect> {
//   MyMissionsBloc() : super(MyMissionsState.initial()) {
//     on<MyMissionsInit>(init);
//   }
//
//   FutureOr<void> init(MyMissionsInit event, Emitter<MyMissionsState> emit) async {}
// }
