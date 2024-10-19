import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class AddCardDetailsViewModel extends ChangeNotifier {
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;
  bool _useGlassMorphism = false;
  bool _useBackgroundImage = true;
  bool _useFloatingAnimation = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String get cardNumber => _cardNumber;
  String get expiryDate => _expiryDate;
  String get cardHolderName => _cardHolderName;
  String get cvvCode => _cvvCode;
  bool get isCvvFocused => _isCvvFocused;
  bool get useGlassMorphism => _useGlassMorphism;
  bool get useBackgroundImage => _useBackgroundImage;
  bool get useFloatingAnimation => _useFloatingAnimation;

  void setUseGlassMorphism(bool value) {
    _useGlassMorphism = value;
    notifyListeners();
  }

  void setUseBackgroundImage(bool value) {
    _useBackgroundImage = value;
    notifyListeners();
  }

  void setUseFloatingAnimation(bool value) {
    _useFloatingAnimation = value;
    notifyListeners();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    _cardNumber = creditCardModel.cardNumber;
    _expiryDate = creditCardModel.expiryDate;
    _cardHolderName = creditCardModel.cardHolderName;
    _cvvCode = creditCardModel.cvvCode;
    _isCvvFocused = creditCardModel.isCvvFocused;
    notifyListeners();
  }

  Glassmorphism? getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient);
  }

  void saveForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
  }

  void onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      // _navigationService.back(
      //   result: CreditCardModel(
      //     _cardNumber,
      //     _expiryDate,
      //     _cardHolderName,
      //     _cvvCode,
      //     _isCvvFocused,
      //   ),
      // );
    } else {
      // _navigationService.back();
    }
  }
}
