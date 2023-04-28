import 'package:foresh_flutter/presentation/signup/bloc/sign_up_form.dart';

class RequestSignUp {
  final SignUpForm data;
  final String? profileImage;

  RequestSignUp({
    required this.data,
    required this.profileImage,
  });
}
