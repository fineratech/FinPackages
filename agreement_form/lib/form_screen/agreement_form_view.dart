import 'package:agreement_form/form_screen/agreement_form_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class AgreementFormView extends StatelessWidget {
  const AgreementFormView({
    super.key,
    required this.agreementType,
    required this.onDone,
  });
  final String agreementType;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AgreementFormViewModel(
        agreementType: agreementType,
      ),
      builder: (context, child) {
        return Scaffold(
          appBar: CustomAppBar(title: "Agreement Form"),
          body: Consumer<AgreementFormViewModel>(
            builder: (context, viewModel, _) {
              return viewModel.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : viewModel.errorMessage != null
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                viewModel.errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                              SizedBox(height: 20),
                              CustomButton(
                                onPressed: () {
                                  viewModel.getAgreementFormData(agreementType);
                                },
                                child: Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.agreementData ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Accept the agreement by signing below:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: SfSignaturePad(
                                    key: viewModel.signatureGlobalKey,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  viewModel.clearSignature();
                                },
                                child: Text("Clear Signature"),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  onPressed: () {
                                    viewModel.onSubmit(
                                      context: context,
                                      onDone: onDone,
                                    );
                                  },
                                  child: Text("Submit"),
                                ),
                              ),
                            ],
                          ),
                        );
            },
          ),
        );
      },
    );
  }
}
