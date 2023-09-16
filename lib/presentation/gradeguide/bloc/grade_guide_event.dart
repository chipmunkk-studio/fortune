import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GradeGuideEvent extends Equatable {}

class GradeGuideInit extends GradeGuideEvent {
  GradeGuideInit();

  @override
  List<Object?> get props => [];
}