class GQLMutations {
  ///user data insert to db
  String createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String dob,
    required String city,
    required String phoneNumber,
    required String loginType,
    required String cognitoId,
    required String accessToken,
  }) {
    return """
  mutation{
    save_social_login_users(input : {
      first_name: "$firstName",
      last_name: "$lastName",
      email: "$email",
      dob: "$dob",
      city: "$city" ,
      phonenumber:"$phoneNumber",
      login_type: "$loginType",
      cognito_id: "$cognitoId",
      access_token: "$accessToken"
    })
  }
  """;
  }

  String deleteUser({required String userId}) {
    return """  
    mutation{
      delete_user(input:{user_id: "$userId"}) {
        data
      }
    }
    """;
  }
}
