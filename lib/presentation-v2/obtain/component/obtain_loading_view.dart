import 'package:flutter/material.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/presentation-v2/main/fortune_main_ext.dart';

class ObtainLoadingView extends StatelessWidget {
  const ObtainLoadingView(this.marker, {super.key});

  final MarkerEntity marker;

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFortuneImage(
                url: marker.image.url,
                width: 92,
                height: 92,
                imageShape: ImageShape.none,
              ),
              const SizedBox(height: 16),
              Text(
                FortuneTr.msgCollectingMarker(marker.name),
                style: FortuneTextStyle.body3Regular(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
