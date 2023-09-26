/*This model is to handle the users from aws cognito , for handling user from mongodb use  */
class User {
  final String? userId;
  final String? cognitoId;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? city;

  User({
    this.userId,
    this.cognitoId,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.city,
  });
}
