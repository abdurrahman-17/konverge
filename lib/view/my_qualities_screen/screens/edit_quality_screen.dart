import 'package:flutter/material.dart';
import '../../../repository/user_repository.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/scrollable_widget.dart';
import '../../results/widgets/result_item_widget.dart';

import '../../../core/app_export.dart';
import '../../../models/skills/skills.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';

// ignore_for_file: must_be_immutable
class EditQualityScreen extends StatefulWidget {
  static const String routeName = '/my_quality_screen';

  const EditQualityScreen({super.key});

  @override
  State<EditQualityScreen> createState() => _EditQualityScreenState();
}

class _EditQualityScreenState extends State<EditQualityScreen> {
  UserInfoModel? user;
  List<Skills> qualitySkillSets = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      BlocProvider.of<GraphqlBloc>(context).add(const ReadInterestsListEvent());
      readUser();
    }
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (userPref != null) user = userPref;
      if ((user?.qualities ?? []).isNotEmpty)
        for (String quality in user?.qualities ?? []) {
          qualitySkillSets.add(Skills(skill: quality));
        }
    });
  }

  TextEditingController titleController = TextEditingController();
  bool isLoading = false;

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
          case MyQualityOrderUpdateSuccess:
            List<String> qualities = [];
            for (Skills skill in qualitySkillSets) {
              qualities.add(skill.skill);
            }
            user!.qualities = qualities;
            Locator.instance.get<UserRepo>().setCurrentUserData(user);
            Navigator.pop(context);
            break;

          case GraphqlErrorState:
            print("Graphql error state: $state");
            break;
          default:
            print("Graphql Unknown state while logging in: $state");
        }
      },
      child: SizedBox(
        height: size.height,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                child: Padding(
                  padding: getPadding(left: 35, right: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TitleString.titleMyQuality,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsSemiBold20,
                      ),
                      Container(
                        // width: getHorizontalSize(298),
                        margin: getMargin(top: 12),
                        child: Text(
                          TitleString.warningNumberOfQuality,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsLight13,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            child: Padding(
                              padding: getPadding(top: 20),
                              child: Container(
                                height: getVerticalSize(
                                  (41 * qualitySkillSets.length).toDouble(),
                                ),
                                width: size.width,
                                color: Colors.transparent,
                                child: ScrollableWidget(
                                  list: qualitySkillSets,
                                  type: "skills",
                                  bgColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Padding(
                              padding: getPadding(top: 20),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: getVerticalSize(7));
                                },
                                itemCount: qualitySkillSets.length,
                                itemBuilder: (context, index) {
                                  return ResultItemWidget(
                                    //bgColor: AppColors.whiteA700,
                                    skill: qualitySkillSets[index],
                                    index: index + 1,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomButton(
                        // height: getVerticalSize(47),
                        text: TitleString.btnSave,
                        enabled: true,
                        onTap: () {
                          // display skill with orders

                          int i = 1;
                          for (Skills skill in qualitySkillSets) {
                            print("skill $i : ${skill.skill}");
                            i++;
                          }

                          BlocProvider.of<GraphqlBloc>(context).add(
                            UpdateMyQualityOrderEvent(
                              myQualityList: qualitySkillSets,
                            ),
                          );
                        },
                        margin: getMargin(top: 30, bottom: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
