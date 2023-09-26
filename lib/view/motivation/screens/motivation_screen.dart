import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/user_repository.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/app_export.dart';
import '../../../core/locator.dart';
import '../../../models/design_models/slider_data.dart';
import '../../../models/graphql/user_info.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/custom_slider.dart';
import '../../common_widgets/loader.dart';

class MotivationScreen extends StatefulWidget {
  static const String routeName = "/motivation";

  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  bool isLoading = false;
  UserInfoModel? user;
  late List<SliderData> slidersMotivation;

  @override
  void initState() {
    super.initState();
    slidersMotivation = [
      SliderData(
        name: TitleString.titleMotivationScreenOptionMoney,
        value: 0,
      ),
      SliderData(
        name: TitleString.titleMotivationScreenOptionPassion,
        value: 0,
      ),
      SliderData(
        name: TitleString.titleMotivationScreenOptionFreedom,
        value: 0,
      ),
      SliderData(
        name: TitleString.titleMotivationScreenOptionLifestyle,
        value: 0,
      ),
      SliderData(
        name: TitleString.titleMotivationScreenOptionHelpingOthers,
        value: 0,
      ),
      SliderData(
        name: TitleString.titleMotivationScreenOptionChangingWorld,
        value: 0,
      ),
      SliderData(
        name: TitleString.titleMotivationScreenOptionFame,
        value: 0,
      ),
    ];

    readUser();
  }

  Future<void> readUser() async {
    log('readUser');
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      log('readUser setState $userPref');
      if (userPref != null) {
        user = userPref;
        // activeUser = user;
        log('readUser setState userPref $user');
        log('readUser setState user?.motivation ${user?.motivation}');
        if (user?.motivation != null) {
          log('readUser mot ${user?.motivation?.money.toDouble()}');
          slidersMotivation = [
            SliderData(
              name: TitleString.titleMotivationScreenOptionMoney,
              value: user?.motivation?.money.toDouble() ?? 0,
            ),
            SliderData(
              name: TitleString.titleMotivationScreenOptionPassion,
              value: user?.motivation?.passion.toDouble() ?? 0,
            ),
            SliderData(
              name: TitleString.titleMotivationScreenOptionFreedom,
              value: user?.motivation?.freedom.toDouble() ?? 0,
            ),
            SliderData(
              name: TitleString.titleMotivationScreenOptionLifestyle,
              value: user?.motivation?.better_lifestyle.toDouble() ?? 0,
            ),
            SliderData(
              name: TitleString.titleMotivationScreenOptionHelpingOthers,
              value: user?.motivation?.helping_others.toDouble() ?? 0,
            ),
            SliderData(
              name: TitleString.titleMotivationScreenOptionChangingWorld,
              value: user?.motivation?.changing_the_world.toDouble() ?? 0,
            ),
            SliderData(
              name: TitleString.titleMotivationScreenOptionFame,
              value: user?.motivation?.fame_and_power.toDouble() ?? 0,
            ),
          ];
        }
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
          case SaveMotivationListSuccessState:
            user?.motivation =
                (state as SaveMotivationListSuccessState).motivation;
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: getPadding(left: 35, right: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRichText(
                    text: "Motivation",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsSemiBold20,
                  ),
                  Container(
                    // width: getHorizontalSize(272),
                    margin: getMargin(top: 10),
                    child: CustomRichText(
                      text:
                          "Use the sliders to indicate your biggest motivations for starting a business. Having similar motivations to your team is key to success.",
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsLight13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: getPadding(top: 22),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: getVerticalSize(5));
                },
                itemCount: slidersMotivation.length,
                itemBuilder: (context, index) {
                  return CustomSlider(
                    data: slidersMotivation[index],
                    onDragComplete: (value) {
                      slidersMotivation[index].value = value;
                    },
                  );
                },
              ),
            ),
            Container(
              padding: getPadding(left: 35, right: 35, bottom: 30),
              child: CustomButton(
                // height: getVerticalSize(47),
                text: "Save",
                enabled: true,
                margin: getMargin(top: 30),
                onTap: () {
                  //make sure the order of items in slidersMotivation is in the same order
                  Motivation request = Motivation(
                    money: slidersMotivation[0].value.toInt(),
                    passion: slidersMotivation[1].value.toInt(),
                    freedom: slidersMotivation[2].value.toInt(),
                    better_lifestyle: slidersMotivation[3].value.toInt(),
                    helping_others: slidersMotivation[4].value.toInt(),
                    changing_the_world: slidersMotivation[5].value.toInt(),
                    fame_and_power: slidersMotivation[6].value.toInt(),
                  );

                  BlocProvider.of<GraphqlBloc>(context).add(
                    UpdateMotivationListEvent(motivation: request),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
