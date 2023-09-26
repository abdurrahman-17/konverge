//this same model will be using for sign up and Otp confirmation using amplify.
class SignUpRequestModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String city;
  SignUpRequestModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.city,
  });
}
