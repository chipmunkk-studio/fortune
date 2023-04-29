import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:foresh_flutter/presentation/main/main_ext.dart';

class MainMarkerView extends StatefulWidget {
  final GlobalKey widgetKey;
  final int id;
  final double latitude;
  final double longitude;
  final dartz.Function4<GlobalKey, int, double, double, void> onMarkerClick;
  final bool disappeared;
  final int grade;

  const MainMarkerView({
    super.key,
    required this.widgetKey,
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.disappeared,
    required this.onMarkerClick,
    required this.grade,
  });

  @override
  State<MainMarkerView> createState() => _MainMarkerViewState();
}

class _MainMarkerViewState extends State<MainMarkerView> with SingleTickerProviderStateMixin {
  final UniqueKey key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: key,
      child: GestureDetector(
        onDoubleTap: () {
          widget.onMarkerClick(
            widget.widgetKey,
            widget.id,
            widget.latitude,
            widget.longitude,
          );
        },
        child: Container(
          key: widget.widgetKey,
          child: !widget.disappeared
              ? getMarkerIcon(
                  widget.grade,
                )
              : getMarkerDisappearedIcon(
                  widget.grade,
                ),
        ),
      ),
    );
  }
}
