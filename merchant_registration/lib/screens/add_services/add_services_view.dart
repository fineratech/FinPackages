import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:merchant_registration/screens/add_services/add_services_view_model.dart';
import 'package:provider/provider.dart';

class AddServicesView extends StatelessWidget {
  const AddServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddServicesViewModel(),
      child: Consumer<AddServicesViewModel>(
        builder: (context, viewModel, _) {
          return const Scaffold(
            appBar: CustomAppBar(title: "Add Services"),
            body: Column(
              children: [],
            ),
          );
        },
      ),
    );
  }
}
