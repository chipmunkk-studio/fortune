import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/presentation/webview/fortune_webview_args.dart';

@immutable
abstract class FortuneWebviewEvent extends Equatable {}

class FortuneWebviewInit extends FortuneWebviewEvent {
  final FortuneWebViewArgs args;

  FortuneWebviewInit(this.args);

  @override
  List<Object?> get props => [];
}
