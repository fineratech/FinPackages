import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:merchant_registration/screens/add_services/add_services_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AddServicesView extends StatelessWidget {
  const AddServicesView({
    super.key,
    required this.type,
    required this.merchantId,
    required this.userId,
    required this.locationId,
    required this.onDone,
  });
  final MerchantType type;
  final int merchantId;
  final int userId;
  final int locationId;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddServicesViewModel(
        context: context,
        type: type,
        merchantId: merchantId,
        userId: userId,
        locationId: locationId,
        onDone: onDone,
      ),
      child: Consumer<AddServicesViewModel>(
        builder: (context, viewModel, _) {
          return ModalProgressHUD(
            inAsyncCall: viewModel.isLoading,
            child: Scaffold(
              appBar: const CustomAppBar(title: "Add Services"),
              body: viewModel.isError
                  ? Column(
                      children: [
                        const Text("Failed to get services"),
                        CustomButton(
                          child: const Text("Retry"),
                          onPressed: () {
                            viewModel.getServices(context);
                          },
                        ),
                      ],
                    )
                  : FormBuilder(
                      key: viewModel.formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            if (viewModel.allServices == null ||
                                viewModel.allServices!.isEmpty)
                              const Center(
                                child: Text("Services not available"),
                              )
                            else ...[
                              CustomDropdownField(
                                name: 'service',
                                items: viewModel.allServices!
                                    .map(
                                      (service) => DropdownMenuItem(
                                        value: service,
                                        child: Text(service.name),
                                      ),
                                    )
                                    .toList(),
                                label: "Service",
                                hintText: "Service",
                                onChanged: (value) {
                                  if (value != null) {
                                    viewModel.selectedService = value;
                                  }
                                },
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                name: 'cost',
                                label: 'Cost',
                                controller: viewModel.costController,
                                textInputType: TextInputType.number,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.positiveNumber()
                                ]),
                              ),
                              if (viewModel.addedServices.isNotEmpty) ...[
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Added Services",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: viewModel.addedServices.length,
                                    itemBuilder: (context, index) {
                                      var service =
                                          viewModel.addedServices[index];
                                      return ListTile(
                                        title: Text(service.name),
                                        trailing: Row(
                                          children: [
                                            Text(service.cost),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                viewModel.deleteService(index);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(
                                height: 80,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      child: const Text("Add Service"),
                                      onPressed: () {
                                        if (viewModel.formKey.currentState!
                                            .saveAndValidate()) {
                                          var newService = viewModel
                                              .selectedService!
                                              .copyWith(
                                            cost: viewModel.costController.text,
                                          );
                                          if (viewModel.addedServices.any(
                                              (element) =>
                                                  element.name ==
                                                  newService.name)) {
                                            Utils.showErrorToast(
                                              context: context,
                                              message: "Service already added",
                                            );
                                            return;
                                          } else {
                                            viewModel.addService(newService);
                                            viewModel.costController.clear();
                                            Utils.showSuccessToast(
                                              context: context,
                                              message:
                                                  "Service added successfully",
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      child: const Text("Next"),
                                      onPressed: () {
                                        if (viewModel.addedServices.isEmpty) {
                                          Utils.showErrorToast(
                                            context: context,
                                            message:
                                                "Please add at least one service",
                                          );
                                          return;
                                        } else {
                                          viewModel.addServicesToDB(
                                            context: context,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
