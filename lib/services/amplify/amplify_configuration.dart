import 'package:flutter_dotenv/flutter_dotenv.dart';

final cognitoOauthDomainUrl = dotenv.env['COGNITO_OAUTH_DOMAIN_URL'];
final appClientId = dotenv.env['APP_CLIENT_ID'];
final signInRedirectUri = dotenv.env['SIGN_IN_REDIRECT_URI'];
final signOutRedirectUri = dotenv.env['SIGN_OUT_REDIRECT_URI'];
final userPoolId = dotenv.env['USER_POOL_ID'];
final region = dotenv.env['REGION'];
final identityPoolId = dotenv.env['IDENTITY_POOL_ID'];
final s3BucketName = dotenv.env['S3_BUCKET_NAME'];

final amplifyConfiguration = {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": {"Default": {}},
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {"PoolId": identityPoolId, "Region": region}
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": userPoolId,
            "AppClientId": appClientId,
            "Region": region
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "OAuth": {
              "WebDomain": cognitoOauthDomainUrl,
              "AppClientId": appClientId,
              "SignInRedirectURI": signInRedirectUri,
              "SignOutRedirectURI": signOutRedirectUri,
              "Scopes": [
                "phone",
                "email",
                "profile",
                "openid",
                // "aws.cognito.signin.user.admin"
              ]
            },
            "socialProviders": [],
            "usernameAttributes": ["PHONE_NUMBER"],
            "signupAttributes": ["EMAIL", "NAME", "PHONE_NUMBER"],
            "passwordProtectionSettings": {
              "passwordPolicyMinLength": 8,
              "passwordPolicyCharacters": []
            },
            "mfaConfiguration": "OFF",
            "mfaTypes": ["SMS"],
            "verificationMechanisms": ["EMAIL"]
          }
        }
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {"bucket": s3BucketName, "region": region}
    }
  }
};
