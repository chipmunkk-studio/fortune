import 'package:flutter/material.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';

class IngredientActionPage extends StatefulWidget {
  final IngredientEntity entity;

  const IngredientActionPage(this.entity, {
    Key? key,
  }) : super(key: key);

  @override
  State<IngredientActionPage> createState() => _IngredientActionPageState();
}

class _IngredientActionPageState extends State<IngredientActionPage> {

  @override
  Widget build(BuildContext context) {
    return _buildProcessWidgetOnType();
  }

  _buildProcessWidgetOnType() {
    switch (widget.entity.type) {
      case IngredientType.ticket:
        return Container();
      default:
        return Container();
    }
  }
}
