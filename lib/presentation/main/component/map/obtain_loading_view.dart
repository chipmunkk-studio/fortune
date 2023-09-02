import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';
import 'package:transparent_image/transparent_image.dart';

import 'main_location_data.dart';

class ObtainLoadingView extends StatelessWidget {
  const ObtainLoadingView({
    super.key,
    required this.isLoading,
    required this.processingMarker,
  });

  final bool isLoading;
  final MainLocationData? processingMarker;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isLoading,
      child: Container(
        color: Colors.black.withOpacity(isLoading ? 0.5 : 0),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 92,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: processingMarker?.ingredient.imageUrl ?? transparentImageUrl,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${processingMarker?.ingredient.name} 줍줍 중..",
                      style: FortuneTextStyle.body3Regular(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
