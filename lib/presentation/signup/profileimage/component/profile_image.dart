import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';

import '../../../../core/util/image_picker.dart';
import '../../bloc/sign_up.dart';

class ProfileImage extends StatelessWidget {
  final SignUpBloc bloc;
  final String defaultProfileImage = "assets/images/default_profile_image.svg";

  const ProfileImage(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return AvatarGlow(
          glowColor: ColorName.primary,
          endRadius: 220.r,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          child: GestureDetector(
            onTap: _onTap,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: CircleAvatar(
                radius: 140.r,
                backgroundColor: ColorName.backgroundLight,
                child: () {
                  final String? profileImage = state.profileImage;
                  return ClipOval(
                    child: profileImage == null
                        ? Assets.icons.icCamera.svg(
                            width: 69.w,
                            height: 69.h,
                          )
                        : Image.file(
                            File(profileImage),
                            width: 340.w,
                            height: 340.h,
                            fit: BoxFit.cover,
                          ),
                  );
                }(),
              ),
            ),
          ),
        );
      },
    );
  }

  // 프로필 이미지 설정 클릭.
  _onTap() {
    FortuneImagePicker().loadImagePicker(
      (path) => bloc.add(SignUpProfileChange(path)),
      () => bloc.add(SignUpRequestStorageAuth()),
    );
  }
}
