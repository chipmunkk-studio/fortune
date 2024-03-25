import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
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
  AnimationController? _animationController;
  Animation<Offset>? _positionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 초기 애니메이션 값을 설정합니다. 실제 사용 시 이전 위도/경도와 새 위도/경도를 기반으로 해야 합니다.
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero, // 여기서 최종 위치를 계산해야 합니다.
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    _animationController!.forward();
  }

  @override
  void didUpdateWidget(covariant MarkerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.marker.latitude != widget.marker.latitude || oldWidget.marker.longitude != widget.marker.longitude) {
      // 위치가 변경되었을 때 새로운 애니메이션 값을 설정합니다.
      // 이 부분에서 실제로는 위도와 경도의 변경을 기반으로 새로운 애니메이션 범위를 설정해야 합니다.
      _positionAnimation = Tween<Offset>(
        begin: Offset.zero, // 시작 위치 계산
        end: const Offset(1.0, 1.0), // 변경된 위치에 따른 종료 위치 계산
      ).animate(CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ));

      _animationController!.reset();
      _animationController!.forward();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation!.value,
            child: Bounceable(
              onTap: () {
                widget.onMarkerClick(widget.marker);
              },
              child: Container(
                child: buildIngredientByPlayType(
                  widget.marker,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
