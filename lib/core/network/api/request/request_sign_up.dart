import 'package:foresh_flutter/presentation/signup/bloc/sign_up_form.dart';

class RequestSignUp {
  final SignUpForm data;
  final String? profileImage;
  final String? pushToken;

  RequestSignUp({
    required this.data,
    required this.profileImage,
    required this.pushToken,
  });
}
