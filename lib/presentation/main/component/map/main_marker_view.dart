import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:fortune/presentation/main/main_ext.dart';

class MainMarkerView extends StatefulWidget {
  final MainLocationData marker;
  final dartz.Function2<MainLocationData, GlobalKey, void> onMarkerClick;

  const MainMarkerView({
    super.key,
    required this.marker,
    required this.onMarkerClick,
  });

  @override
  State<MainMarkerView> createState() => _MainMarkerViewState();
}

class _MainMarkerViewState extends State<MainMarkerView> {
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _uniqueKey,
      child: Bounceable(
        onTap: () async {
          widget.onMarkerClick(
            widget.marker,
            widget.marker.globalKey,
          );
        },
        child: Container(
          key: widget.marker.globalKey,
          child: buildIngredientByPlayType(widget.marker.ingredient),
        ),
      ),
    );
  }
}
