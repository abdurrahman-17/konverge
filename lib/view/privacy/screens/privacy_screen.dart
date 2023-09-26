import 'package:flutter/material.dart';
import '../../../models/blocked_user_model.dart';
import '../../../repository/user_repository.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../authentication/screens/privacy_policy.dart';
import '../../common_widgets/loader.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../../core/app_export.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_switch.dart';
import '../widgets/privacy_item_widget.dart';

class PrivacyScreen extends StatefulWidget {
  static const String routeName = "/privacy";

  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool isLoading = false;
  bool isPushNotificationOn = false;
  bool isOnlyAllowMatchesToMessage = false;
  bool isAllowPeopleToSendManualRequest = false;
  UserInfoModel? user;

  @override
  void initState() {
    super.initState();

    readUser();
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();

    if (userPref != null) {
      user = userPref;
      setState(() {
        if (user?.is_notification != null) {
          isPushNotificationOn = user!.is_notification;
        }
        if (user?.allow_matches_message != null) {
          isOnlyAllowMatchesToMessage = user!.allow_matches_message;
        }
        if (user?.allow_mannualy_match_requests != null) {
          isAllowPeopleToSendManualRequest =
              user!.allow_mannualy_match_requests;
        }
      });
    }
    fetchBlockedUserData();
  }

  void fetchBlockedUserData() {
    if (user != null) {
      BlocProvider.of<GraphqlBloc>(context).add(
        GetBlockedUserEvent(userId: user!.userId!),
      );
    }
  }

  // List<UserInfoModel> blockedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          opacity: 0.6,
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [contents(context), if (isLoading) Loader()],
          ),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  List<BlockedUserModel> blockedUsers = [];

  Widget contents(BuildContext context) {
    return BlocConsumer<GraphqlBloc, GraphqlState>(
        listener: (BuildContext context, state) {
      setState(() {
        isLoading = false;
      });
      switch (state.runtimeType) {
        case QueryLoadingState:
          setState(() {
            isLoading = true;
          });
          break;
        case PrivacyScreenValuesUpdateSuccessState:
          user?.is_notification =
              (state as PrivacyScreenValuesUpdateSuccessState)
                  .isPushNotificationOn;
          user?.allow_matches_message =
              (state as PrivacyScreenValuesUpdateSuccessState)
                  .isAllowMatchesMessage;
          user?.allow_mannualy_match_requests =
              (state as PrivacyScreenValuesUpdateSuccessState)
                  .isAllowPeopleToSendManualRequest;
          Locator.instance.get<UserRepo>().setCurrentUserData(user!);
          Navigator.pop(context);
          break;
        case GraphqlErrorState:
          print(
              "GraphqlErrorState: $state ${(state as GraphqlErrorState).errorMessage}");
          break;
        case UnBlockSuccessState:
          fetchBlockedUserData();
          break;
        case BlockSuccessState:
          fetchBlockedUserData();
          break;
        case GetBlockedUsersState:
          blockedUsers = (state as GetBlockedUsersState).users;
          break;
        default:
          print("Unknown state while logging in: $state");
      }
    }, builder: (BuildContext context, state) {
      return SingleChildScrollView(
        child: Container(
          padding: getPadding(left: 35, right: 35, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Privacy",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtPoppinsSemiBold20,
              ),
              Container(
                padding: getPadding(top: 10),
                child: Text(
                  "We know how important it is to keep your data private. Rest easy that we have all your concerns covered here",
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsLight13,
                ),
              ),
              Padding(
                padding: getPadding(top: 50),
                child: Text(
                  "Permissions",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsSemiBold13,
                ),
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: getPadding(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomRichText(
                        text: "Only allow matches to message you",
                        style: AppStyle.txtPoppinsRegular13,
                        textAlign: TextAlign.left,
                      ),
                      CustomSwitch(
                        value: isOnlyAllowMatchesToMessage,
                        onToggle: (value) {
                          isOnlyAllowMatchesToMessage = value;
                        },
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRichText(
                      text: "Allow people to manually match request",
                      style: AppStyle.txtPoppinsRegular13,
                      textAlign: TextAlign.left,
                    ),
                    CustomSwitch(
                      value: isAllowPeopleToSendManualRequest,
                      onToggle: (value) {
                        isAllowPeopleToSendManualRequest = value;
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: Divider(
                  height: getVerticalSize(1),
                  thickness: getVerticalSize(1),
                  color: AppColors.gray50033,
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: Text(
                  "Manage push notifications",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsSemiBold13,
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRichText(
                      text: "Allow push notifications",
                      style: AppStyle.txtPoppinsRegular13,
                      textAlign: TextAlign.left,
                    ),
                    CustomSwitch(
                      value: isPushNotificationOn,
                      onToggle: (value) {
                        isPushNotificationOn = value;
                        if(value){
                          requestPushNotificationPermissionFromOS();
                        }
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: Divider(
                  height: getVerticalSize(1),
                  thickness: getVerticalSize(1),
                  color: AppColors.gray50033,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PrivacyPolicyScreen.routeName,
                  );
                },
                child: Padding(
                  padding: getPadding(top: 20),
                  child: Text(
                    "Privacy Policy",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsSemiBold13,
                  ),
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: Divider(
                  height: getVerticalSize(1),
                  thickness: getVerticalSize(1),
                  color: AppColors.gray50033,
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: Text(
                  "Blocked accounts",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsSemiBold13,
                ),
              ),
              Padding(
                padding: getPadding(top: 15),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: getVerticalSize(11));
                  },
                  itemCount: blockedUsers.length,
                  itemBuilder: (context, index) {
                    return PrivacyItemWidget(user: blockedUsers[index]);
                  },
                ),
              ),
              CustomButton(
                // height: getVerticalSize(47),
                text: "Save",
                enabled: true,
                margin: getMargin(top: 80),
                onTap: () {
                  updatePushNotificationValueToSever();
                },
              )
            ],
          ),
        ),
      );
    });
  }

  void updatePushNotificationValueToSever() {
    setState(() {
      isLoading = true;
      BlocProvider.of<GraphqlBloc>(context).add(
        UpdatePrivacyScreenDataEvent(
          isAllowMatchesMessage: isOnlyAllowMatchesToMessage,
          isPushNotificationOn: isPushNotificationOn,
          isAllowPeopleToSendManualRequest: isAllowPeopleToSendManualRequest,
        ),
      );
    });
  }
}
