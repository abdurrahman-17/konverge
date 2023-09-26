import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../repository/user_repository.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/app_export.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/pre_questionnaire_info_request.dart';
import '../../../models/graphql/user_info.dart';
import '../../../models/skills/skills.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';
import '../../common_widgets/loader.dart';
import '../widgets/skill_item.dart';
import '../widgets/skill_item_selected.dart';
import 'ideas_screen.dart';

// ignore_for_file: must_be_immutable
class SearchForSkillsScreen extends StatefulWidget {
  static const String routeName = '/search_for_skill';
  PreQuestionnaireInfoModel? requestModel;
  bool isSecondTime = false;

  SearchForSkillsScreen({
    super.key,
    this.requestModel,
    required this.isSecondTime,
  });

  @override
  State<SearchForSkillsScreen> createState() => _SearchForSkillsScreenState();
}

class _SearchForSkillsScreenState extends State<SearchForSkillsScreen> {
  TextEditingController group554Controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isInvestor = false;
  bool isFromSettings = false;
  int maximumSelectableSkills = 4;
  List<Skills> searchSkillSets = [];
  List<Skills> totalSkillSets = [];
  List<Skills> selectedItems = [];
  UserInfoModel? user = Locator.instance.get<UserRepo>().getCurrentUserData();

  final FocusNode _focusNode = FocusNode();
  TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    isInvestor = true;
    if (widget.requestModel == null) {
      isFromSettings = true;
    }
    if (mounted) {
      searchSkillSets = BlocProvider.of<GraphqlBloc>(context).skills;
      totalSkillSets = BlocProvider.of<GraphqlBloc>(context).skills;
      searchData("");
      selectedItems = [];
      if (widget.requestModel == null &&
          !widget.isSecondTime &&
          user != null &&
          user?.personal_skills != null) {
        if (!alreadyFetched) {
          for (Skills item in user?.personal_skills ?? []) {
            selectedItems.add(item);
          }
          alreadyFetched = true;
        }
      }
      if (widget.requestModel == null &&
          widget.isSecondTime &&
          user != null &&
          user?.looking_for_skills != null) {
        if (!alreadyFetched) {
          for (Skills item in user?.looking_for_skills ?? []) {
            selectedItems.add(item);
          }
          alreadyFetched = true;
        }
      }
      if (searchSkillSets.isEmpty) {
        BlocProvider.of<GraphqlBloc>(context).add(const ReadSkillsListEvent());
      }
    }
  }

  /*Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (userPref != null) user = userPref;
      // activeUser = user;
    });
  }*/

  int totalResults = 10;
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
          body: contents(context),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
         if (isLoading) const Loader(),
      ],
    );
  }

  bool isItemSelected(Skills skills) {
    for (Skills item in selectedItems) {
      if (item.skill == skills.skill) {
        return true;
      }
    }
    return false;
  }

  void removeItemFromSelectedList(Skills skills) {
    for (Skills item in selectedItems) {
      if (item.skill == skills.skill) {
        setState(() {
          selectedItems.remove(item);
        });
        break;
      }
    }
  }

  bool alreadyFetched = false;

  Widget contents(BuildContext context) {
    String title = TitleString.titleSearchForYourSkills;
    String noSelectedItems = TitleString.titleNonSelectedYourSkills;
    String description = TitleString.warningNumberOfSkills;
    String titleSelectedSkills = TitleString.titleSelectedSkills;
    String buttonName = TitleString.btnSave;
    if (widget.requestModel != null) {
      buttonName = TitleString.btnNext;
    }
    if (isInvestor && widget.isSecondTime) {
      title = TitleString.titleSearchForYourSkillsInvestor;
      description = TitleString.warningNumberOfSkillsInvestor;
      titleSelectedSkills = TitleString.titleSelectedSkillsInvestor;
      maximumSelectableSkills = 8;
      noSelectedItems = TitleString.titleNonSelectedLookingSkills;
    }
    return SizedBox(
      height: size.height,
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Stack(alignment: Alignment.center, children: [
          Align(
            child: Padding(
              padding: getPadding(left: 35, right: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsSemiBold20,
                  ),
                  Container(
                    // width: getHorizontalSize(298),
                    margin: getMargin(top: 12),
                    child: Text(
                      description,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsLight13,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: _focusNode,
                    controller: titleController,
                    hintText: TitleString.startSearchingHint,
                    margin: getMargin(top: 18),
                    onChanged: (value) {
                      searchData(value.toLowerCase());
                    },

                    onSubmitted: (value) {
                      //   FocusManager.instance.primaryFocus?.unfocus();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      searchData(value.toLowerCase());
                      FocusScope.of(context).unfocus();
                    },
                    padding: TextFormFieldPadding.paddingV15H25,
                    textInputAction: TextInputAction.search,
                    variant: TextFormFieldVariant.outlineBlack90035,
                    // ?TODO poppins grey
                    hintStyle:
                        TextFormFieldFontStyle.poppinsRegular12WhiteA7007f,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    shape: TextFormFieldShape.roundedBorder50,
                  ),
                  Stack(
                    children: [
                      BlocConsumer<GraphqlBloc, GraphqlState>(
                        listener: (BuildContext context, state) {
                          switch (state.runtimeType) {
                            case SaveSkillsLookingForListSuccessState:
                              user?.looking_for_skills = (state
                                      as SaveSkillsLookingForListSuccessState)
                                  .skillsLookingFor;
                              Locator.instance
                                  .get<UserRepo>()
                                  .setCurrentUserData(user!);
                              if (mounted) Navigator.pop(context, true);
                              break;
                            case SavePersonalSkillsListSuccessState:
                              user?.personal_skills =
                                  (state as SavePersonalSkillsListSuccessState)
                                      .personalSkills;
                              Locator.instance
                                  .get<UserRepo>()
                                  .setCurrentUserData(user!);

                              if (mounted) Navigator.pop(context);
                              break;
                          }
                        },
                        builder: (BuildContext context, state) {
                          isLoading = false;
                          switch (state.runtimeType) {
                            case SkillsLoadingState:
                              isLoading = true;
                              break;
                            case QueryUpdateSuccessState:
                              break;
                            case SkillsListReadSuccessState:
                              state as SkillsListReadSuccessState;
                              if (widget.requestModel == null &&
                                  !widget.isSecondTime &&
                                  user != null &&
                                  user?.personal_skills != null) {
                                if (!alreadyFetched) {
                                  for (Skills item
                                      in user?.personal_skills ?? []) {
                                    selectedItems.add(item);
                                  }
                                  alreadyFetched = true;
                                }
                              }
                              if (widget.requestModel == null &&
                                  widget.isSecondTime &&
                                  user != null &&
                                  user?.looking_for_skills != null) {
                                if (!alreadyFetched) {
                                  for (Skills item
                                      in user?.looking_for_skills ?? []) {
                                    selectedItems.add(item);
                                  }
                                  alreadyFetched = true;
                                }
                              }
                              totalSkillSets = state.skills;
                              searchSkillSets = state.skills;

                              break;
                            case SkillsSearchSuccessState:
                              searchSkillSets =
                                  (state as SkillsSearchSuccessState).list;
                              break;
                            case SaveSkillsLookingForListSuccessState:
                              user?.looking_for_skills = (state
                                      as SaveSkillsLookingForListSuccessState)
                                  .skillsLookingFor;
                              Locator.instance
                                  .get<UserRepo>()
                                  .setCurrentUserData(user!);
                              break;
                            case SavePersonalSkillsListSuccessState:
                              user?.personal_skills =
                                  (state as SavePersonalSkillsListSuccessState)
                                      .personalSkills;
                              Locator.instance
                                  .get<UserRepo>()
                                  .setCurrentUserData(user!);
                              break;
                            case GraphqlErrorState:
                              print("Graphql error state: $state");
                              break;
                            default:
                              print(
                                  "Graphql Unknown state while logging in: $state");
                          }
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isLoading)
                                Center(child: Loader()),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: getMargin(top: 24),
                                    child: Text(
                                      "${searchSkillSets.length} Results",
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtPoppinsLight13,
                                    ),
                                  ),
                                  Container(
                                    margin: getMargin(top: 17),
                                    height: 326,
                                    child: Scrollbar(
                                      controller: scrollController,
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: ListView.builder(
                                          itemCount: searchSkillSets.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                log("index $index : ${searchSkillSets[index].skill}");
                                                if (isItemSelected(
                                                    searchSkillSets[index])) {
                                                  removeItemFromSelectedList(
                                                      searchSkillSets[index]);
                                                } else {
                                                  if (selectedItems.length <
                                                      maximumSelectableSkills) {
                                                    selectedItems.add(
                                                        searchSkillSets[index]);
                                                  }
                                                }
                                                setState(() {});
                                              },
                                              child: SkillItem(
                                                skill: searchSkillSets[index],
                                                isSelected: isItemSelected(
                                                    searchSkillSets[index]),
                                                isLast: index ==
                                                    searchSkillSets.length - 1,
                                                index: index,
                                                length: selectedItems.length,
                                                maxSelectLimit:
                                                    maximumSelectableSkills,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: getPadding(top: 17),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          titleSelectedSkills,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style:
                                              AppStyle.txtPoppinsMedium16WhiteA700,
                                        ),
                                        if (selectedItems.isNotEmpty)
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedItems.clear();
                                              });
                                            },
                                            child: Padding(
                                              padding: getPadding(
                                                left: 5,
                                                right: 5,
                                                top: 2,
                                                bottom: 2,
                                              ),
                                              child: Text(
                                                "Clear all",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtPoppinsRegular11WhiteA700,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (selectedItems.isEmpty)
                                    Container(
                                      margin: getMargin(top: 21),
                                      child: Text(
                                        noSelectedItems,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtPoppinsLightItalic10,
                                      ),
                                    ),
                                  if (selectedItems.isNotEmpty)
                                    Container(
                                      margin: getMargin(top: 18),
                                      child: Wrap(
                                        runSpacing: getVerticalSize(5),
                                        spacing: getHorizontalSize(5),
                                        children: List<Widget>.generate(
                                          selectedItems.length,
                                          (index) => SkillItemSelected(
                                            skill: selectedItems[index],
                                            onTap: () {
                                              setState(() {
                                                removeItemFromSelectedList(
                                                  selectedItems[index],
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                        // child: Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       margin: getMargin(top: 24),
                        //       child: Text(
                        //         "${searchSkillSets.length} Results",
                        //         textAlign: TextAlign.left,
                        //         style: AppStyle.txtPoppinsLight13,
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: getMargin(top: 17),
                        //       height: 326,
                        //       child: SingleChildScrollView(
                        //         child: ListView.builder(
                        //           itemCount: searchSkillSets.length,
                        //           shrinkWrap: true,
                        //           physics: const NeverScrollableScrollPhysics(),
                        //           itemBuilder: (context, index) {
                        //             return InkWell(
                        //               onTap: () {
                        //                 if (isItemSelected(searchSkillSets[index])) {
                        //                   removeItemFromSelectedList(
                        //                       searchSkillSets[index]);
                        //                 } else {
                        //                   if (selectedItems.length <
                        //                       maximumSelectableSkills) {
                        //                     selectedItems.add(searchSkillSets[index]);
                        //                   }
                        //                 }
                        //                 setState(() {});
                        //               },
                        //               child: SkillItem(
                        //                 skill: searchSkillSets[index],
                        //                 isSelected:
                        //                 isItemSelected(searchSkillSets[index]),
                        //                 isLast: index == searchSkillSets.length - 1,
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: getPadding(top: 17),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             titleSelectedSkills,
                        //             overflow: TextOverflow.ellipsis,
                        //             textAlign: TextAlign.left,
                        //             style: AppStyle.txtPoppinsMedium16WhiteA700,
                        //           ),
                        //           if (selectedItems.isNotEmpty)
                        //             InkWell(
                        //               onTap: () {
                        //                 setState(() {
                        //                   selectedItems.clear();
                        //                 });
                        //               },
                        //               child: Padding(
                        //                 padding: getPadding(
                        //                   left: 5,
                        //                   right: 5,
                        //                   top: 2,
                        //                   bottom: 2,
                        //                 ),
                        //                 child: Text(
                        //                   "Clear all",
                        //                   overflow: TextOverflow.ellipsis,
                        //                   textAlign: TextAlign.left,
                        //                   style: AppStyle.txtPoppinsRegular11WhiteA700,
                        //                 ),
                        //               ),
                        //             ),
                        //         ],
                        //       ),
                        //     ),
                        //     if (selectedItems.isEmpty)
                        //       Container(
                        //         margin: getMargin(top: 21),
                        //         child: Text(
                        //           noSelectedItems,
                        //           textAlign: TextAlign.left,
                        //           style: AppStyle.txtPoppinsLightItalic10,
                        //         ),
                        //       ),
                        //     if (selectedItems.isNotEmpty)
                        //       Container(
                        //         margin: getMargin(top: 18),
                        //         child: Wrap(
                        //           runSpacing: getVerticalSize(5),
                        //           spacing: getHorizontalSize(5),
                        //           children: List<Widget>.generate(
                        //             selectedItems.length,
                        //                 (index) => SkillItemSelected(
                        //               skill: selectedItems[index],
                        //               onTap: () {
                        //                 setState(() {
                        //                   removeItemFromSelectedList(
                        //                     selectedItems[index],
                        //                   );
                        //                 });
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //
                        //   ],
                        // ),
                      ),
                      if (isLoading)
                        Align(
                          child: Container(
                            margin: getMargin(top: 20),
                            child: const Loader(),
                          ),
                        ),
                    ],
                  ),
                  CustomButton(
                    // height: getVerticalSize(47),
                    text: buttonName,
                    enabled: selectedItems.isNotEmpty,
                    onTap: () {
                      if (selectedItems.isEmpty) {
                        showInfo(
                          context,
                          content: "Select at least one skill",
                          buttonLabel: TitleString.btnOkay,
                        );
                        return;
                      }
                      if (widget.requestModel != null) {
                        if (isInvestor && !widget.isSecondTime) {
                          widget.requestModel?.myPersonalSkills = selectedItems;

                          /*check weather the user is looking for investor, if yes skip skills you are looking for*/
                          if (widget.requestModel?.lookingForInvestOrPartner ==
                              Constants.lookingForTypeInvestor) {
                            widget.requestModel?.skillsLookingFor = [];
                            Navigator.pushNamed(
                              context,
                              IdeasScreen.routeName,
                              arguments: {
                                'data': widget.requestModel,
                              },
                            );
                          } else {
                            Navigator.pushNamed(
                              context,
                              SearchForSkillsScreen.routeName,
                              arguments: {
                                'data': widget.requestModel,
                                'isSecondTime': true
                              },
                            );
                          }
                        } else {
                          widget.requestModel?.skillsLookingFor = selectedItems;
                          Navigator.pushNamed(
                            context,
                            IdeasScreen.routeName,
                            arguments: {
                              'data': widget.requestModel,
                            },
                          );
                        }
                      } else {
                        if (widget.isSecondTime) {
                          BlocProvider.of<GraphqlBloc>(context).add(
                            UpdateSkillsLookingForListEvent(
                              skills: selectedItems,
                            ),
                          );
                        } else {
                          BlocProvider.of<GraphqlBloc>(context).add(
                            UpdatePersonalSkillsListEvent(
                              skills: selectedItems,
                            ),
                          );
                        }
                        for (Skills item in selectedItems) {
                          print("Saving skills: ${item.skill}");
                        }
                      }
                    },
                    margin: getMargin(top: 40, bottom: 30),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void searchData(String query) {
    BlocProvider.of<GraphqlBloc>(context).add(
      SearchSkillsListEvent(
        skills: totalSkillSets,
        query: query,
      ),
    );
  }
}
