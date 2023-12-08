import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/web/command/fortune_web_command_close.dart';
import 'package:fortune/domain/supabase/entity/web/fortune_web_query_param.dart';
import 'package:fortune/presentation-web/fortune_web_ext.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../verifycode/web_verify_code_bottom_sheet.dart';
import 'bloc/web_retire.dart';
import 'component/web_retire_button.dart';
import 'component/web_retire_email_input_field.dart';

class WebRetirePage extends StatelessWidget {
  const WebRetirePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<WebRetireBloc>()..add(WebRetireInit()),
      child: const _WebRetirePage(),
    );
  }
}

class _WebRetirePage extends StatefulWidget {
  const _WebRetirePage();

  @override
  State<_WebRetirePage> createState() => _WebRetirePageState();
}

class _WebRetirePageState extends State<_WebRetirePage> {
  late WebRetireBloc _bloc;
  final webRouter = serviceLocator<FortuneWebRouter>().router;
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<WebRetireBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<WebRetireBloc, WebRetireSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is WebRetireError) {
          dialogService.showWebErrorDialog(
            context,
            sideEffect.error,
            needToFinish: false,
          );
        } else if (sideEffect is WebRetireShowVerifyCodeBottomSheet) {
          await context.showBottomSheet(
            isDismissible: false,
            content: (context) => WebVerifyCodeBottomSheet(
              email: sideEffect.email,
              isRetire: true,
            ),
          );
        } else if (sideEffect is WebRetireWithdrawalUser) {
          dialogService.showFortuneDialog(
            context,
            subTitle: FortuneTr.msgAlreadyWithdrawn,
            dismissOnBackKeyPress: true,
            btnOkPressed: () {},
          );
        } else if (sideEffect is WebRetireNotExistUser) {
          dialogService.showFortuneDialog(
            context,
            subTitle: FortuneTr.msgNotExistUser,
            dismissOnBackKeyPress: true,
            btnOkPressed: () {},
          );
        }
      },
      child: BlocBuilder<WebRetireBloc, WebRetireState>(
        builder: (context, state) {
          return Scaffold(
            appBar: FortuneCustomAppBar.leadingAppBar(
              context,
              leadingIcon: Assets.icons.icWebCi.svg(),
              onPressed: () async {
                await requestWebUrl(
                  command: FortuneWebCommandClose(
                    sample: '테스트',
                  ),
                  queryParams: FortuneWebQueryParam(testData: '테스트데이터').toJson(),
                );
              },
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(FortuneTr.msgConfirmWithdrawal, style: FortuneTextStyle.headLine1(height: 1.3)),
                        const SizedBox(height: 40),
                        // 로그인 상태.
                        BlocBuilder<WebRetireBloc, WebRetireState>(
                          buildWhen: (previous, current) => previous.email != current.email,
                          builder: (context, state) {
                            return WebRetireEmailInputField(
                              email: state.email,
                              emailController: _phoneNumberController,
                              onTextChanged: (text) => _bloc.add(WebRetireEmailInput(text)),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<WebRetireBloc, WebRetireState>(
                  buildWhen: (previous, current) => previous.isButtonEnabled != current.isButtonEnabled,
                  builder: (context, state) {
                    return WebRetireButton(
                      text: FortuneTr.msgVerifyYourself,
                      isKeyboardVisible: true,
                      isEnabled: state.isButtonEnabled,
                      onPressed: () {
                        _bloc.add(WebRetireBottomButtonClick());
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
