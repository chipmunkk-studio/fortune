// import 'package:app_settings/app_settings.dart';
// import 'package:flutter/material.dart';
// import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
// import 'package:foresh_flutter/core/widgets/dialog/defalut_dialog.dart';
// import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../fortune_router.dart';
//
// class RequirePermissionPage extends StatefulWidget {
//   const RequirePermissionPage({Key? key}) : super(key: key);
//
//   @override
//   State<RequirePermissionPage> createState() => _RequirePermissionPageState();
// }
//
// class _RequirePermissionPageState extends State<RequirePermissionPage> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     requestPermissions();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   // 앱 상태 변경시 호출
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         // PermissionStatus status = await Permission.location.status;
//         // PermissionStatus status = await Permission.sms.status;
//         // PermissionStatus status = await Permission.photos.status;
//         // PermissionStatus status = await Permission.storage.status;
//         if (status.isGranted) {
//           if (!mounted) return;
//           FortuneRouter().router.navigateTo(
//                 context,
//                 Routes.enterProfileImageRoute,
//                 clearStack: true,
//               );
//         }
//         break;
//       case AppLifecycleState.inactive:
//         // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
//         // ios에서는 포그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
//         // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
//         // inactive가 발생되고 얼마후 pasued가 발생합니다.
//         print("inactive");
//         break;
//       case AppLifecycleState.paused:
//         // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
//         // 안드로이드의 onPause()와 동일합니다.
//         // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.
//         print("paused");
//         break;
//       case AppLifecycleState.detached:
//         // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
//         // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
//         // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
//         print("detached");
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FortuneAnnotatedRegion(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FortuneElevatedButton(
//             text: "위치 권한 요청하기",
//             press: () => context.showFortuneDialog(
//               title: '권한이 필요합니다.',
//               subTitle: '위치 접근 권한을 허용해주세요',
//               btnOkText: '허용하러 가기',
//               btnOkPressed: () => AppSettings.openAppSettings(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   void requestPermissions() async {
//     Map<Permission, PermissionStatus> statuses = await [Permission.location, Permission.sms, Permission.photos, Permission.storage].request();
//
//     if (statuses[Permission.location] == PermissionStatus.granted &&
//         statuses[Permission.sms] == PermissionStatus.granted &&
//         statuses[Permission.photos] == PermissionStatus.granted &&
//         statuses[Permission.storage] == PermissionStatus.granted) {
//       if (!mounted) return;
//       FortuneRouter().router.navigateTo(
//             context,
//             Routes.navigationRoute,
//             clearStack: true,
//           );
//     }
//   }
// }
