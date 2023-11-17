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

class FortuneWebviewLoadingComplete extends FortuneWebviewEvent {
  FortuneWebviewLoadingComplete();

  @override
  List<Object?> get props => [];
}

class FortuneWebviewLoading extends FortuneWebviewEvent {
  final int progress;

  FortuneWebviewLoading(this.progress);

  @override
  List<Object?> get props => [];
}
