import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../main/bloc/main_state.dart';

class ItemObtainHistory extends StatelessWidget {
  final ObtainHistoryContentViewItem item;

  const ItemObtainHistory(
    this.item, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: ColorName.backgroundLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 21),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item.ingredient.name} (${item.markerId})", style: FortuneTextStyle.body1SemiBold()),
                const SizedBox(height: 6),
                Text(
                  item.locationName,
                  style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox.square(
            dimension: 60,
            child: ClipOval(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.ingredient.imageUrl.isEmpty ? transparentImageUrl : item.ingredient.imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
