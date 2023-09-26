import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/graphql/graphql_bloc.dart';
import '../../../../blocs/graphql/graphql_event.dart';
import '../../../../blocs/graphql/graphql_state.dart';
import '../../../../repository/user_repository.dart';
import '../../../../utilities/title_string.dart';
import '../../../../core/locator.dart';
import '../../../../services/comet_chat.dart';
import '../../../results/screens/investment_screen.dart';
import '../launch_screen.dart';

import '../../../../core/app_export.dart';
import '../../../../utilities/design_utils/home_item.dart';
import '../../widgets/home/home_item_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
    required this.zoomDrawerController,
  });

  final zoomDrawerController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  void initState() {
    BlocProvider.of<GraphqlBloc>(context).add(
      ReadMatchCountEvent(),
    );
    super.initState();
  }

  int matchCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GraphqlBloc, GraphqlState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          switch (state.runtimeType) {
            case ReadMatchCountSuccessState:
              state as ReadMatchCountSuccessState;
              matchCount = state.count;
              homeItems[2].count = matchCount;
              print('Match notificiation count: $matchCount');
              break;
            case GraphqlInitialState:
              activeUser =
                  Locator.instance.get<UserRepo>().getCurrentUserData();
              break;
          }
          return Stack(
            children: [
              // CommonBgLogo(
              //   opacity: 0.6,
              //   position: CommonBgLogoPosition.bottomLeft,
              // ),
              Container(
                height: size.height,
                color: Colors.transparent,
                padding: getPadding(left: 35, right: 35, top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: TitleString.homeWelcomeMessagePrefix,
                            style: TextStyle(
                              color: AppColors.whiteA700,
                              fontSize: getFontSize(20),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextSpan(
                            text: "${activeUser?.firstname}",
                            style: TextStyle(
                              color: AppColors.whiteA700,
                              fontSize: getFontSize(20),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      padding: getPadding(top: 31),
                      width: getHorizontalSize(305),
                      child: Center(
                        child: Wrap(
                          runSpacing: getVerticalSize(19),
                          spacing: getHorizontalSize(19),
                          children: List<Widget>.generate(
                            homeItems.length,
                            (index) => HomeItemWidget(
                              homeModel: homeItems[index],
                              onTapColumnUser: () => onTapColumnUser(
                                context,
                                homeItems[index].name,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void onTapColumnUser(BuildContext context, String name) {
    var arg = {"tab": 0};
    String rootName = LaunchScreen.routeName;
    String smallName = name.toLowerCase();
    switch (smallName) {
      case "match":
        print("New flow Clicked on matches");
        arg = {"tab": 1};
        break;
      case "search":
        print("New flow Clicked on matches");

        arg = {"tab": 2};
        break;
      case "my profile":
        arg = {"tab": 3};
        break;
    }
    if (smallName.contains("settings") && widget.zoomDrawerController != null) {
      widget.zoomDrawerController.toggle?.call();
    } else if (smallName.contains("investment")) {
      Navigator.pushNamed(
        context,
        InvestmentScreen.routeName,arguments: {"isFromHome": true}
      );
    } else if (smallName.contains("message")) {
      cometChatView(context);
    } else {
      Navigator.pushReplacementNamed(
        context,
        rootName,
        arguments: arg,
      );
    }
  }
}
