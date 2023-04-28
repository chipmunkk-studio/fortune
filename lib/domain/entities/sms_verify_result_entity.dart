import 'package:equatable/equatable.dart';

class SmsVerifyCodeConfirmEntity extends Equatable {
  final bool registered;
  final String? accessToken;
  final String? refreshToken;

  const SmsVerifyCodeConfirmEntity({
    required this.registered,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
