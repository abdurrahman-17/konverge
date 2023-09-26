import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/user_repository.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/locator.dart';
import '../../../models/design_models/slider_data.dart';
import '../../../models/graphql/user_info.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/loader.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_bg_logo.dart';

import '../../../theme/app_style.dart';
import '../../../utilities/size_utils.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_slider.dart';

class PassionScreen extends StatefulWidget {
  static const String routeName = "/passion";

  const PassionScreen({super.key});

  @override
  State<PassionScreen> createState() => _PassionScreenState();
}

class _PassionScreenState extends State<PassionScreen> {
  bool isLoading = false;
  UserInfoModel? user;
  SliderData sliderPassion = SliderData(name: "Passion", value: 0);

  @override
  void initState() {
    super.initState();
    readUser();
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (userPref != null) user = userPref;
      if (user != null && user?.level_of_passion != null) {
        sliderPassion.value = user?.level_of_passion?.toDouble() ?? 0;
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
          case SaveLevelOfPassionSuccessState:
            user?.level_of_passion =
                (state as SaveLevelOfPassionSuccessState).passion;
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
            padding: getPadding(left: 35, right: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level of Passion",
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsSemiBold20,
                ),
                Container(
                  margin: getMargin(top: 10),
                  child: Text(
                    "Use the slider to indicate how passionate you are about starting a business.",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsLight13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: getPadding( top: 22),
            child: CustomSlider(
              data: sliderPassion,
              onDragComplete: (double value) {
                sliderPassion.value = value;
              },
            ),
          ),
          const Spacer(),
          Container(
            padding: getPadding(left: 35, right: 35, bottom: 30),
            child: CustomButton(
              // height: getVerticalSize(47),
              text: TitleString.btnSave,
              enabled: true,
              margin: getMargin(top: 30),
              onTap: () {
                BlocProvider.of<GraphqlBloc>(context).add(
                  UpdateLevelOfPassionEvent(
                    passion: sliderPassion.value.toInt(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
