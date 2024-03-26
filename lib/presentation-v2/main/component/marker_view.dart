import 'package:flutter/material.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/presentation-v2/main/fortune_main_ext.dart';

class MarkerView extends StatefulWidget {
  final MarkerEntity marker;
  final Function(MarkerEntity) onMarkerClick;

  const MarkerView({
    super.key,
    required this.marker,
    required this.onMarkerClick,
  });

  @override
  State<MarkerView> createState() => _MarkerViewState();
}

class _MarkerViewState extends State<MarkerView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onMarkerClick(widget.marker),
      child: buildIngredientByPlayType(
        url: widget.marker.image.url,
        type: widget.marker.image.type,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
