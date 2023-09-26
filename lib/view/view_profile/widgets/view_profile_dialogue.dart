import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user_detail/user_detail_bloc.dart';
import '../../../models/graphql/user_info.dart';
import '../../../core/app_export.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../repository/user_repository.dart';
import '../../../services/comet_chat.dart';

class ViewProfileDialog extends StatelessWidget {
  final UserInfoModel? user;
  final String matchType;
  final String from;
  int lastTimeClicked;

  ViewProfileDialog(
      {super.key,
      required this.user,
      required this.matchType,
      this.from = "",
        this.lastTimeClicked = 0,
      this.intervalMs = 1000});

  int intervalMs;
  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  Widget build(BuildContext context) {
    bool messageVisibilityStatus = false;
    bool isUserAlreadyMatchedWithMe = true;
    bool matchButtonVisibilityStatus = true;
    if (user != null &&
        user!.statusData != null &&
        user!.statusData?.blockStatus != null) {
      messageVisibilityStatus = ((user!.statusData != null
              ? user!.statusData!.matchStatus == "Matched"
              : false) &&
          (user!.statusData != null
              ? user!.statusData!.blockStatus == false
              : true));

      isUserAlreadyMatchedWithMe =
          ((user!.statusData!.matchStatus.toString().toLowerCase() ==
                  "matched") ||
              (user!.statusData!.matchStatus.toString().toLowerCase() ==
                  "Already Request Sent".toLowerCase()));
      print("Jithin: Block: " + user!.statusData!.blockStatus.toString());
      print("Jithin: isUserAlreadyMatchedWithMe: " +
          isUserAlreadyMatchedWithMe.toString());
      print("Jithin: allow_mannualy_match_requests: " +
          user!.allow_mannualy_match_requests.toString());
      matchButtonVisibilityStatus = (!user!
              .statusData!.blockStatus! /*user should not be blocked.*/ &&
          (isUserAlreadyMatchedWithMe || user!.allow_mannualy_match_requests));
    }
    return Container(
      width: getHorizontalSize(305),
      padding: getPadding(left: 20, top: 18, right: 20, bottom: 18),
      decoration: AppDecoration.fillBlueGray90002
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: matchButtonVisibilityStatus,
            child: InkWell(
              onTap: () {
                //  onTapRowMatch(context, "Match request sent!");
                Navigator.pop(context);
                if (from == "detail") {
                  if (user!.statusData != null
                      ? (user!.statusData!.matchStatus
                              .toString()
                              .toLowerCase() !=
                          "matched")
                      : true) {
                    BlocProvider.of<UserDetailBloc>(context).add(
                      MatchUserDetailEvent(
                          userId: activeUser!.userId!,
                          user: user!,
                          isMatch: true,
                          matchType: this.matchType),
                    );
                  } else {
                    BlocProvider.of<UserDetailBloc>(context).add(
                      MatchUserDetailEvent(
                          userId: activeUser!.userId!,
                          user: user!,
                          isMatch: false,
                          matchType: this.matchType),
                    );
                  }
                } else {
                  if (user!.statusData != null
                      ? (user!.statusData!.matchStatus
                              .toString()
                              .toLowerCase() !=
                          "matched")
                      : true) {
                    BlocProvider.of<UserBloc>(context).add(
                      MatchUserEvent(
                          userId: activeUser!.userId!,
                          user: user!,
                          isMatch: true,
                          matchType: this.matchType),
                    );
                  } else {
                    BlocProvider.of<UserBloc>(context).add(
                      MatchUserEvent(
                          userId: activeUser!.userId!,
                          user: user!,
                          isMatch: false,
                          matchType: this.matchType),
                    );
                  }
                }
              },
              child: Padding(
                padding: getPadding(left: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        (user!.statusData != null
                            ? (user!.statusData!.matchStatus
                                        .toString()
                                        .toLowerCase() ==
                                    "matched")
                                ? "Unmatch"
                                : "Match"
                            : "Match"),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLight13WhiteA700),
                    CustomLogo(
                      svgPath: Assets.imgArrowRightTealA400,
                      height: getVerticalSize(10),
                      width: getHorizontalSize(5),
                      margin: getMargin(top: 4, bottom: 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: matchButtonVisibilityStatus,
            child: Padding(
              padding: getPadding(top: 13),
              child: Divider(
                height: getVerticalSize(1),
                thickness: getVerticalSize(1),
                color: AppColors.gray4001e,
                indent: getHorizontalSize(1),
              ),
            ),
          ),
          Visibility(
            visible: (messageVisibilityStatus),
            child: InkWell(
              onTap: () {
                // cometChatUserRedirection(context,user?.userId ?? "",user?.fullname ?? "",Constants.getProfileUrl(

                final now = DateTime.now().millisecondsSinceEpoch;
                if (now - lastTimeClicked < intervalMs) {
                  print("multi tap");
                  return;
                }
                lastTimeClicked = now;
                cometChatRedirections(context, user?.userId ?? "");
                // Navigator.pop(context);
              },
              child: Padding(
                padding: getPadding(left: 1, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Message",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsLight13WhiteA700,
                    ),
                    CustomLogo(
                      svgPath: Assets.imgArrowRightTealA400,
                      height: getVerticalSize(10),
                      width: getHorizontalSize(5),
                      margin: getMargin(top: 4, bottom: 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible:
                messageVisibilityStatus /*((user!.statusData != null
                        ? user!.statusData!.matchStatus == "Matched"
                        : false) ||
                    (!user!.allow_matches_message)) &&
                (user!.statusData != null
                    ? user!.statusData!.blockStatus == false
                    : true)*/
            ,
            child: Padding(
              padding: getPadding(top: 14),
              child: Divider(
                height: getVerticalSize(1),
                thickness: getVerticalSize(1),
                color: AppColors.gray4001e,
                indent: getHorizontalSize(1),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              if (activeUser != null) {
                log("usr ${user!.toJson()}");
                if (from == "detail") {
                  BlocProvider.of<UserDetailBloc>(context).add(
                    (user!.statusData != null &&
                            user!.statusData!.blockStatus == true)
                        ? UnblockUserDetailEvent(
                            userId: activeUser!.userId!,
                            interestedId: user!.userId!)
                        : BlockUserDetailEvent(
                            userId: activeUser!.userId!,
                            interestedId: user!.userId!),
                  );
                } else {
                  BlocProvider.of<UserBloc>(context).add(
                    (user!.statusData != null &&
                            user!.statusData!.blockStatus == true)
                        ? UnblockUserEvent(
                            userId: activeUser!.userId!,
                            interestedId: user!.userId!)
                        : BlockUserEvent(
                            userId: activeUser!.userId!,
                            interestedId: user!.userId!),
                  );
                }
              }

              // onTapRowMatch(context, "You have blocked this user");
            },
            child: Padding(
              padding: getPadding(left: 1, top: 7, bottom: 2),
              child: Text(
                (user!.statusData != null &&
                        user!.statusData!.blockStatus == true)
                    ? "Unblock"
                    : "Block",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtPoppinsMedium13RedA200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTapRowMatch(BuildContext context, String message) {
    Navigator.pop(context);
  }
}
