import 'package:entity_registration/src/Screens/entity_registration_screen.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';

class RegistrationSuccessView extends StatelessWidget {
  const RegistrationSuccessView({
    super.key,
    required this.onDone,
    required this.entityType,
    required this.ownerId,
  });
  final VoidCallback onDone;
  final EntityType entityType;
  final String ownerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EntityRegistrationScreen(
                entityType: entityType,
                onDone: onDone,
                ownerId: ownerId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            "assets/images/check.png",
            height: 120,
            width: 120,
            package: 'entity_registration',
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Account registered successfully",
            style: TextStyle(
              fontSize: 22,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          CustomButton(
            onPressed: onDone,
            child: const Text("Next"),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}