//
// Future<void> openMarkerStream(Emitter<MainState> emit) async {
//   Supabase.instance.client.from('markers').stream(
//     primaryKey: ['id'],
//   ).listen(
//         (List<Map<String, dynamic>> data) async {
//       final markers = data.map((item) => MarkerResponse.fromJson(item)).toList();
//       final ingredientIds = markers.map((e) => e.ingredient_.toInt()).toList();
//       final ingredientsList = await getIngredientsUseCase(ingredientIds).then(
//             (value) => value.getOrElse(() => List.empty()),
//       );
//       // 마커 목록을 뽑아옴.
//       final List<MarkerMapEntity> markerEntities = markers.map(
//             (e) {
//           final matchedElement = ingredientsList.where((element) => element.id == e.ingredientId).single;
//           return MarkerMapEntity(
//             id: e.id,
//             ingredient: matchedElement,
//             latitude: e.latitude,
//             longitude: e.longitude,
//             isExtinct: e.isExtinct,
//             isRandomLocation: e.isRandomLocation,
//             lastObtainUser: e.lastObtainUser,
//           );
//         },
//       ).toList();
//       // 마커들.
//       final changeLocationList = markerEntities
//           .map(
//             (e) => MainLocationData(
//           id: e.id,
//           location: LatLng(e.latitude, e.longitude),
//           disappeared: false,
//           ingredient: e.ingredient,
//         ),
//       )
//           .toList();
//       add(MainMarkerLocationChange(changeLocationList));
//     },
//     onError: (e) {
//       produceSideEffect(
//         MainError(
//           CommonFailure(
//             errorCode: HttpStatus.badRequest.toString(),
//             errorMessage: e.toString(),
//           ),
//         ),
//       );
//       FortuneLogger.error("onError: ${e.toString()}");
//     },
//   );
// }