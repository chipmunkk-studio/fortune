import 'package:flutter/material.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/main/main_ext.dart';

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
                    buildIngredientByPlayType(
                      processingMarker?.ingredient ?? IngredientEntity.empty(),
                      width: 92,
                      height: 92,
                      imageShape: ImageShape.none,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      FortuneTr.msgCollectingMarker(processingMarker?.ingredient.exposureName ?? ''),
                      style: FortuneTextStyle.body3Light(),
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
