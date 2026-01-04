import 'package:entity_registration/src/Screens/lawer/basic_info/basic_info_view.dart';
import 'package:entity_registration/src/Screens/lawer/id_info/id_info_view.dart';
import 'package:entity_registration/src/Screens/lawer/license_info/license_info_view.dart';
import 'package:entity_registration/src/Screens/lawer/register_lawer_view_model.dart';

import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class RegisterLawerScreen extends StatelessWidget {
  const RegisterLawerScreen({
    super.key,
    required this.onDone,
    required this.merchantId,
    required this.userId,
    required this.type,
    required this.locationId,
  });
  final void Function(dynamic) onDone;
  final String merchantId;
  final String userId;
  final EntityType type;
  final String locationId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterLawerViewModel(
        merchantId: merchantId,
        userId: userId,
        onDone: onDone,
        locationId: locationId,
        context: context,
        onError: (message) {
          Utils.showErrorToast(
            context: context,
            message: message,
          );
        },
      ),
      builder: (context, _) {
        return Consumer<RegisterLawerViewModel>(
          builder: (context, viewModel, _) {
            return ModalProgressHUD(
              inAsyncCall: viewModel.isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      allowImplicitScrolling: false,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: viewModel.pageController,
                      children: [
                        BasicInfoView(
                          onJumpToPage: viewModel.jumpToPage,
                          saveLawer: viewModel.saveLawer,
                          merchantId: merchantId,
                        ),
                        LicenseInfoView(
                          onJumpToPage: viewModel.jumpToPage,
                          savelawer: viewModel.saveLawer,
                        ),
                        IdInfoView(
                          onJumpToPage: viewModel.jumpToPage,
                          saveLawer: viewModel.saveLawer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
