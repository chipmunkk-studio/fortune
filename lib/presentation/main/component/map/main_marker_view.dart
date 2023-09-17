import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:transparent_image/transparent_image.dart';

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
      child: GestureDetector(
        onDoubleTap: () async {
          widget.onMarkerClick(
            widget.marker,
            widget.marker.globalKey,
          );
        },
        child: Container(
          key: widget.marker.globalKey,
          // 획득 유저가 있고, 소멸성 인 경우 >  쓰레기 마커.
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.marker.ingredient.imageUrl,
          ),
        ),
      ),
    );
  }
}
