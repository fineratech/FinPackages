import 'package:entity_registration/src/Screens/therapist/basic_info/basic_info_view.dart';
import 'package:entity_registration/src/Screens/therapist/id_info/id_info_view.dart';
import 'package:entity_registration/src/Screens/therapist/license_info/license_info_view.dart';
import 'package:entity_registration/src/Screens/therapist/register_therapist_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class RegisterTherapistScreen extends StatelessWidget {
  const RegisterTherapistScreen({
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
      create: (context) => RegisterTherapistViewModel(
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
        return Consumer<RegisterTherapistViewModel>(
          builder: (context, viewModel, _) {
            return ModalProgressHUD(
              inAsyncCall: viewModel.isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: viewModel.pageController,
                      children: [
                        BasicInfoView(
                          onJumpToPage: viewModel.jumpToPage,
                          saveTherapist: viewModel.saveTherapist,
                          merchantId: merchantId,
                        ),
                        LicenseInfoView(
                          onJumpToPage: viewModel.jumpToPage,
                          saveTherapist: viewModel.saveTherapist,
                        ),
                        IdInfoView(
                          onJumpToPage: viewModel.jumpToPage,
                          saveTherapist: viewModel.saveTherapist,
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
