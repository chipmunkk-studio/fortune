import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/gen/fonts.gen.dart';

theme() {
  return ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    checkboxTheme: _checkboxThemeData(),
    unselectedWidgetColor: ColorName.grey800,
    scaffoldBackgroundColor: ColorName.grey900,
    fontFamily: FontFamily.pretendardRegular,
    appBarTheme: appBarTheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
    textButtonTheme: textButtonTheme(),
    bottomSheetTheme: bottomSheetTheme(),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: ColorName.primary),
    inputDecorationTheme: inputDecorationTheme(),
    bottomNavigationBarTheme: bottomNavigationBarTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

_checkboxThemeData() {
  return CheckboxThemeData(
    side: const BorderSide(
      width: 1.5,
      color: ColorName.grey700,
    ),
    splashRadius: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.r),
    ),
    checkColor: MaterialStateProperty.resolveWith<Color>((states) => Colors.black),
    fillColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (!states.contains(MaterialState.selected)) {
          return ColorName.grey700; // 체크박스가 선택된경우.
        }
        return ColorName.primary; // 체크박스가 활성화된 경우
      },
    ),
    overlayColor: MaterialStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(MaterialState.pressed)) {
          return ColorName.primary; // 체크박스가 눌린 경우
        }
        return Colors.transparent; // 체크박스가 눌리지 않은 경우
      },
    ),
  );
}

bottomSheetTheme() {
  return const BottomSheetThemeData(
    backgroundColor: ColorName.grey800,
  );
}

elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.r),
      ),
      // Enabled button color
      backgroundColor: ColorName.primary,
      // Disabled button color
      disabledBackgroundColor: ColorName.grey600,
      // Enabled text color
      foregroundColor: ColorName.grey900,
      // Disabled text color
      disabledForegroundColor: ColorName.grey400,
      textStyle: FortuneTextStyle.button1Medium(),
    ).copyWith(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) return Colors.transparent;
          return null;
        },
      ),
    ),
  );
}

bottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: ColorName.grey900,
    selectedLabelStyle: TextStyle(
      fontFamily: FontFamily.pretendardRegular,
      color: Colors.white,
      fontSize: 13.sp,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: FontFamily.pretendardRegular,
      color: ColorName.grey700,
      fontSize: 13.sp,
    ),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white,
    unselectedItemColor: ColorName.grey700,
    showUnselectedLabels: true,
    showSelectedLabels: true,
  );
}

inputDecorationTheme() {
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    // contentPadding: const EdgeInsets.fromLTRB(20, 16, 0, 16),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorName.grey700),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorName.grey700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorName.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorName.negative),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: ColorName.grey700),
    ),
    counterStyle: const TextStyle(color: ColorName.primary),
  );
}

textButtonTheme() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      // 버튼의 텍스트 색상을 변경
      foregroundColor: Colors.white,
      // 버튼의 배경색을 변경
      backgroundColor: ColorName.grey800,
      disabledBackgroundColor: ColorName.grey700,
      // 버튼의 최소 크기 설정
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    ),
  );
}

appBarTheme() {
  return AppBarTheme(
    // 상단 스테이터스 바 컬러.
    color: ColorName.grey900,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white24),
    toolbarTextStyle: FortuneTextStyle.subTitle2Medium(),
    titleTextStyle: FortuneTextStyle.subTitle2Medium(),
    titleSpacing: 0.w,
    toolbarHeight: 60.h,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      // For iOS (dark icons)
      statusBarIconBrightness: Brightness.light,
      // For Android (dark icons)
      systemNavigationBarIconBrightness: Brightness.light,
      // 네비게이션 바 컬러.
      systemNavigationBarColor: ColorName.grey900,
    ),
  );
}
