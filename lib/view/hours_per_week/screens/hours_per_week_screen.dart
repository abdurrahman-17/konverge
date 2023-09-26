import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/user_repository.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/locator.dart';
import '../../../models/design_models/slider_data.dart';
import '../../../models/graphql/user_info.dart';
import '../../common_widgets/loader.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_bg_logo.dart';

import '../../../core/app_export.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_slider.dart';

class HoursPerWeekScreen extends StatefulWidget {
  static const String routeName = "/hours_per_week";

  const HoursPerWeekScreen({super.key});

  @override
  State<HoursPerWeekScreen> createState() => _HoursPerWeekScreenState();
}

class _HoursPerWeekScreenState extends State<HoursPerWeekScreen> {
  bool isLoading = false;
  UserInfoModel? user;
  SliderData hoursPerWeek = SliderData(
    name: "Hours per week",
    value: 0,
  );

  @override
  void initState() {
    super.initState();
    readUser();
  }

  Future<void> readUser() async {
    var currentUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (currentUser != null) user = currentUser;
      if (user != null && user?.hours_per_week != null) {
        hoursPerWeek.value = user!.hours_per_week!.toDouble();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          opacity: 0.6,
          position: CommonBgLogoPosition.bottomRight,
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              contents(context),
              if (isLoading) const Loader(),
            ],
          ),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    return BlocListener<GraphqlBloc, GraphqlState>(
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
          case QueryUpdateSuccessState:
            break;
          case SaveHoursPerWeekSuccessState:
            user?.hours_per_week =
                (state as SaveHoursPerWeekSuccessState).hours;
            Locator.instance.get<UserRepo>().setCurrentUserData(user!);

            Navigator.pop(context);
            break;
          case GraphqlErrorState:
            print("Graphql error state: $state");
            break;
          default:
            print("Graphql Unknown state while logging in: $state");
        }
      },
      child: Column(
        children: [
          Container(
            padding: getPadding(left: 34, right: 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hours per week",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsSemiBold20,
                ),
                Container(
                  width: getHorizontalSize(272),
                  margin: getMargin(top: 10, right: 33),
                  child: Text(
                    "How many hours you will be able to work on your business per week. It's important that you are aligned with any partners.",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsLight13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: getPadding(  top: 22),
            child: CustomSlider(
              data: hoursPerWeek,
              onDragComplete: (double value) {
                hoursPerWeek.value = value;
              },
            ),
          ),
          const Spacer(),
          Container(
            padding: getPadding(left: 35, right: 35, bottom: 30),
            child: CustomButton(
              // height: getVerticalSize(47),
              text: "Save",
              enabled: true,
              margin: getMargin(top: 30),
              onTap: () {
                BlocProvider.of<GraphqlBloc>(context).add(
                  UpdateHoursPerWeekEvent(
                    hours: hoursPerWeek.value.toInt(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
