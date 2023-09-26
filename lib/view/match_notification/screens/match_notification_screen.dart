import 'package:flutter/material.dart';

import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../core/app_export.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/notification/notification_model.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../view_profile/screens/view_profile_screen.dart';
import '../widget/match_item_widget.dart';

class MatchNotificationScreen extends StatefulWidget {
  static const String routeName = "/match_notification";

  const MatchNotificationScreen({super.key});

  @override
  State<MatchNotificationScreen> createState() =>
      _MatchNotificationScreenState();
}

class _MatchNotificationScreenState extends State<MatchNotificationScreen> {
  int selectedTabBar = 0;
  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  void initState() {
    BlocProvider.of<NotificationBloc>(context).add(
      GetNotificationListEvent(userId: activeUser!.userId!),
    );
    super.initState();
  }

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
          body: notificationBlocData(context),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  bool loading = false;
  List<NotificationModel> manualNotifications = [];
  List<NotificationModel> algorithmicNotifications = [];

  Widget notificationBlocData(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        loading = true;
        if (state is UpdateNotificationReadSuccessStatus) {
          BlocProvider.of<GraphqlBloc>(context).add(
            ReadMatchCountEvent(),
          );
        }
        if (state is NotificationListState) {
          if (state.status == ProviderStatus.loading) {
            loading = true;
          } else if (state.status == ProviderStatus.loaded) {
            loading = false;
            manualNotifications = state.manualNotifications;
            algorithmicNotifications = state.algorithmicNotifications;
          } else if (state.status == ProviderStatus.error) {
            loading = false;
          }
        }

        return contents(context);
      },
    );
  }

  Widget contents(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Padding(
        padding: getPadding(left: 35, right: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: CustomRichText(
                text: "Match Request Notifications",
                textAlign: TextAlign.center,
                style: AppStyle.txtPoppinsMedium19,
              ),
            ),
            Padding(
              padding: getPadding(top: 15),
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      selectedTabBar = index;
                    });
                  },
                  indicatorColor: AppColors.teal400,
                  tabs: [
                    Container(
                      padding: getPadding(bottom: 10),
                      child: CustomRichText(
                        text: "Algorithm",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtPoppinsRegular16,
                      ),
                    ),
                    Container(
                      padding: getPadding(bottom: 10),
                      child: CustomRichText(
                        text: "Manual",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtPoppinsRegular16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Builder(
                  builder: (_) {
                    return listView(
                      selectedTabBar == 0
                          ? algorithmicNotifications
                          : manualNotifications,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listView(List<NotificationModel> notifications) {
    return Padding(
      padding: getPadding(top: 46),
      child: notifications.isNotEmpty
          ? ListView.separated(
              itemCount: notifications.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (notifications[index].cognitoId != null) {
                      BlocProvider.of<GraphqlBloc>(context).add(
                        UpdateNotificationReadStatusEvent(
                          notificationId: notifications[index].sId ?? "",
                        ),
                      );

                      Navigator.pushNamed(
                        context,
                        ViewProfileScreen.routeName,
                        arguments: {
                          "from": "",
                          "cognitoId": notifications[index].cognitoId,
                          "current": activeUser?.userId,
                          "userId": notifications[index].senderId,
                        },
                      );
                    }
                  },
                  child: MatchItemWidget(
                    notification: notifications[index],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: getVerticalSize(8),
                );
              },
            )
          : Center(
              child: Container(
                padding: getPadding(top: 250),
                child: loading
                    ? Loader()
                    : CustomRichText(
                        text: "No Notifications Found!",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtPoppinsBoldItalic20,
                      ),
              ),
            ),
    );
  }
}
