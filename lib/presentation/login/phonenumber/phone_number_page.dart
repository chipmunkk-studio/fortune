import 'package:easy_localization/easy_localization.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/phone_number.dart';
import 'component/country_code.dart';
import 'component/phone_number_bottom_button.dart';
import 'component/phone_number_input_field.dart';

class PhoneNumberPage extends StatelessWidget {
  final String? countryCode;
  final String? countryName;

  const PhoneNumberPage({
    Key? key,
    this.countryCode,
    this.countryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<PhoneNumberBloc>()
        ..add(
          PhoneNumberInit(
            countryCode,
            countryName,
          ),
        ),
      child: const _PhoneNumberPage(),
    );
  }
}

class _PhoneNumberPage extends StatefulWidget {
  const _PhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<_PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<_PhoneNumberPage> {
  late PhoneNumberBloc bloc;
  late TextEditingController phonNumberTextEditingController;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    bloc = BlocProvider.of<PhoneNumberBloc>(context);
    phonNumberTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<PhoneNumberBloc, PhoneNumberSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is PhoneNumberError) {}
      },
      child: Scaffold(
        appBar: const FortuneEmptyAppBar(),
        body: SafeArea(
          bottom: false,
          child: KeyboardVisibilityBuilder(
            builder: (BuildContext context, bool isKeyboardVisible) {
              return Container(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: isKeyboardVisible ? 0 : 20,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 100),
                              Text('require_certify_phone_number'.tr(), style: FortuneTextStyle.headLine3()),
                              const SizedBox(height: 40),
                              CountryCode(router, onTap: (countryCodeArgs) {
                                bloc.add(
                                  PhoneNumberChangeCountryCode(
                                    countryCodeArgs.countryCode,
                                    countryCodeArgs.countryName,
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),
                              BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
                                builder: (context, state) {
                                  return PhoneNumberInputField(
                                    state,
                                    textEditingController: phonNumberTextEditingController,
                                    onSuffixIconClick: () {
                                      bloc.add(PhoneNumberCancel());
                                    },
                                    onTextChanged: (text) {
                                      bloc.add(PhoneNumberInput(text));
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: EdgeInsets.only(
                        left: isKeyboardVisible ? 0 : 20,
                        right: isKeyboardVisible ? 0 : 20,
                        bottom: isKeyboardVisible ? 0 : 20,
                      ),
                      curve: Curves.easeInOut,
                      child: BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
                        builder: (context, state) {
                          return PhoneNumberBottomButton(isKeyboardVisible, router, state);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
