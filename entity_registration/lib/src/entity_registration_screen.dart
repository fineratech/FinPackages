import 'package:entity_registration/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'widgets/custom_text_field.dart';

class EntityRegistrationScreen extends StatefulWidget {
  const EntityRegistrationScreen({super.key});

  @override
  State<EntityRegistrationScreen> createState() =>
      _EntityRegistrationScreenState();
}

class _EntityRegistrationScreenState extends State<EntityRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Entity Registration'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  name: 'name',
                  label: 'Name',
                  onChanged: (value) {
                    print(value);
                  },
                ),
                CustomTextField(
                  name: 'qualification',
                  label: 'Qualification',
                  onChanged: (value) {
                    print(value);
                  },
                ),
                CustomTextField(
                  name: 'gender',
                  label: 'Gender',
                  onChanged: (value) {
                    print(value);
                  },
                ),
                CustomTextField(
                  name: 'dob',
                  label: 'Date of Birth',
                  onChanged: (value) {
                    print(value);
                  },
                ),
                CustomTextField(
                  name: 'certification',
                  label: 'Certification',
                  onChanged: (value) {
                    print(value);
                  },
                ),
                CustomTextField(
                  name: 'services',
                  label: 'Services',
                  onChanged: (value) {
                    print(value);
                  },
                ),
                const SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    child: Text('Submit'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
