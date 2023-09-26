import '../core/app_export.dart';

import 'title_string.dart';

class Validation {
  //email validator
  static String? emailValidation(String? email) {
    RegExp regExp = RegExp(Constants.emailValidationPattern);
    if (email == null || email.isEmpty) {
      return TitleString.emailEmpty;
    }
    if (!regExp.hasMatch(email)) {
      return TitleString.invalidEmail;
    }
    return null;
  }

// amount validator
  static String? validateAmount(String amount) {
    if (amount == '') {
      return TitleString.amountEmpty;
    }
    if (amount == '0') {
      return TitleString.zeroAmount;
    }
    try {
      double convert = double.parse(amount);
      if (convert > 0) {
        return null;
      } else {
        return TitleString.invalidAmount;
      }
    } on Exception {
      return TitleString.invalidAmount;
    }
  }

  //password validator
  static String? passwordValidation(String? password) {
    // Regular expressions for special characters and numbers and alphabet
    final RegExp characterRegex = RegExp(Constants.passwordCharacterRegex);
    final RegExp specialCharRegex = RegExp(Constants.passwordSpecialCharRegex);
    final RegExp numberRegex = RegExp(Constants.passwordNumberRegex);

    if (password == null || password.isEmpty) {
      return TitleString.passwordEmpty;
    }
    if (password.length < 8) {
      return TitleString.passwordMinError;
    }
    if (password.length > 16) {
      return TitleString.passwordMaxError;
    }
    // Password should have at least 1 alphabet
    if (!characterRegex.hasMatch(password)) {
      return TitleString.passwordAlphabetError;
    }
    // Password should contain at least 1 numeric value
    if (!numberRegex.hasMatch(password)) {
      return TitleString.passwordNumberError;
    }
    // Password should contain at least 1 special character
    if (!specialCharRegex.hasMatch(password)) {
      return TitleString.passwordSpecialCharacterError;
    }

    return null;
  }

  //login password validator
  // static String? loginPasswordValidation(String? password) {
  //   RegExp regExp = RegExp(Constants.passwordValidationPattern);
  //   if (password == null || password.isEmpty) {
  //     return TitleString.passwordEmpty;
  //   }
  //   return null;
  // }
  //newPassword Validator
  static String? newPasswordValidation(String? password, String? previous) {
    // Regular expressions for special characters and numbers and alphabet
    final RegExp characterRegex = RegExp(Constants.passwordCharacterRegex);
    final RegExp specialCharRegex = RegExp(Constants.passwordSpecialCharRegex);
    final RegExp numberRegex = RegExp(Constants.passwordNumberRegex);

    if (password == null || password.isEmpty) {
      return TitleString.passwordEmpty;
    }
    if (password.length < 8) {
      return TitleString.passwordMinError;
    }
    if (password.length > 16) {
      return TitleString.passwordMaxError;
    }
    // Password should have at least 1 alphabet
    if (!characterRegex.hasMatch(password)) {
      return TitleString.passwordAlphabetError;
    }
    // Password should contain at least 1 numeric value
    if (!numberRegex.hasMatch(password)) {
      return TitleString.passwordNumberError;
    }
    // Password should contain at least 1 special character
    if (!specialCharRegex.hasMatch(password)) {
      return TitleString.passwordSpecialCharacterError;
    }
    if (password == previous) {
      return TitleString.passwordDuplicateError;
    }
    return null;
  }

  //mobile number validator
  static String? mobileNumberValidation(String? number) {
    RegExp regExp = RegExp(Constants.phoneNumberValidationPattern);
    RegExp regExp2 = RegExp(Constants.phoneNumberValidationPattern2);
    if (number == null || number.isEmpty) {
      return TitleString.phoneFiledEmpty;
    }
    // if (number.length != 10) {
    //   return TitleString.invalidPhoneNumber;
    // }

    if (number.startsWith("0")) {
      return TitleString.phoneNumberShouldNotStartWithZero;
    }
    if (number.length < 7 || number.length > 15) {
      return TitleString.invalidPhoneNumber;
    }
    if (!regExp.hasMatch(number)) {
      return TitleString.invalidPhoneNumber;
    }
    if (!regExp2.hasMatch(number)) {
      return TitleString.invalidPhoneNumber;
    }
    return null;
  }

  static String? nameValidation(String? name, String title, int minLetter,
      {int? maxLength}) {
    if (name == null || name.isEmpty || name.trim().isEmpty) {
      return "$title ${Constants.isRequired}";
    }
    if (name.length < minLetter ||
        name.length > (maxLength ?? Constants.nameLength)) {
      String titleValue = title.toLowerCase().contains("name") ? "Name" : title;
      return "$titleValue should contain min $minLetter and max ${maxLength ?? Constants.nameLength} characters";
    }

    /*final nameValidationRgex = RegExp(Constants.nameValidationRegex);
    if (!nameValidationRgex.hasMatch(name)) {
      return TitleString.invalidNameFormat;
    }*/
    return null;
  }

  static String? emptyCheck(String? inputString) {
    if (inputString == null ||
        inputString.isEmpty ||
        inputString.trim().isEmpty) {
      return TitleString.warningFieldCanNotEmpty;
    }

    return null;
  }

  static String? validateDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null ||
        dateOfBirth.isEmpty ||
        dateOfBirth.trim().isEmpty) {
      return TitleString.warningEmptyDob;
    }

    final dateOfBirthRegExp = RegExp(Constants.dateOfBirthFormat);
    if (!dateOfBirthRegExp.hasMatch(dateOfBirth)) {
      return TitleString.warningDobFormat;
    }

    final dateOfBirthParts = dateOfBirth.split('/');
    if (dateOfBirthParts[0] == '00' ||
        dateOfBirthParts[1] == '00' ||
        dateOfBirthParts[2] == '0000') {
      return TitleString.invalidDate;
    }
    final day = int.tryParse(dateOfBirthParts[0]);
    final month = int.tryParse(dateOfBirthParts[1]);
    final year = int.tryParse(dateOfBirthParts[2]);

    if (day == null || month == null || year == null) {
      return TitleString.warningDobFormat;
    }
    if (!isDateOfBirthValid(dateOfBirth)) {
      return TitleString.warningDobNotExists;
    }

    final now = DateTime.now();
    final userDateOfBirth = DateTime(year, month, day);

    if (userDateOfBirth.isAfter(now)) {
      return TitleString.warningDobMinimumAge;
      // return TitleString.warningDobFuture;
    }

    final difference = now.difference(userDateOfBirth).inDays;
    const minimumAgeInDays = 16 * 365;

    if (difference < minimumAgeInDays) {
      return TitleString.warningDobMinimumAge;
    }

    if (userDateOfBirth.isBefore(now.subtract(Duration(days: 365 * 125)))) {
      return TitleString.warningDobBefore1900;
    }
    return null;
  }
}
