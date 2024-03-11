import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _currentIndex = 0;
  final List<String> _titles = [
    FortuneTr.msgOnboardingTitle1,
    FortuneTr.msgOnboardingTitle2,
    FortuneTr.msgReceiveReward,
  ];
  final List<String> _descriptions = [
    FortuneTr.msgOnboarding1,
    FortuneTr.msgOnboarding2,
    FortuneTr.msgOnboarding3,
  ];

  final List<String> _onboardingImage = [
    Assets.images.onboarding.guide1.path,
    Assets.images.onboarding.guide2.path,
    Assets.images.onboarding.guide3.path,
  ];

  final router = serviceLocator<FortuneAppRouter>().router;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              bool isActive = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4.0),
                width: isActive ? 8 : 8,
                height: isActive ? 8 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? ColorName.primary : ColorName.grey600,
                ),
              );
            }),
          ),
          Expanded(
            child: CarouselSlider.builder(
              itemCount: _titles.length,
              itemBuilder: (context, index, realIdx) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _titles[index],
                      style: FortuneTextStyle.caption1SemiBold(
                        color: ColorName.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _descriptions[index],
                      textAlign: TextAlign.center,
                      style: FortuneTextStyle.headLine1(),
                    ),
                    const SizedBox(height: 12),
                    Image.asset(_onboardingImage[index]),
                  ],
                );
              },
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                height: MediaQuery.of(context).size.height,
                enableInfiniteScroll: false,
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.0,
                initialPage: 0,
              ),
            ),
          ),
          FortuneScaleButton(
            text: FortuneTr.start,
            onPress: () => router.navigateTo(
              context,
              AppRoutes.requestPermissionRoute,
            ),
          ),
        ],
      ),
    );
  }
}
