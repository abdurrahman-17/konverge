import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../repository/user_repository.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/interests.dart';
import '../../../models/graphql/user_info.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/loader.dart';
import '../../search_for_skills/widgets/skill_item.dart';
import '../../search_for_skills/widgets/skill_item_selected.dart';

import '../../../core/app_export.dart';
import '../../../models/skills/skills.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';

// ignore_for_file: must_be_immutable
class SearchForInterest extends StatefulWidget {
  static const String routeName = '/search_for_interests';

  const SearchForInterest({super.key});

  @override
  State<SearchForInterest> createState() => _SearchForInterestState();
}

class _SearchForInterestState extends State<SearchForInterest> {
  int maximumSelectableSkills = 8;
  List<Skills> searchInterestSets = [];
  List<Skills> totalInterestSets = [];
  List<Skills> selectedItems = [];
  UserInfoModel? user;

  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  final FocusNode _focusTitle = FocusNode();
  late int cursorTitle = 0;

  @override
  void initState() {
    _focusTitle.addListener(() {
      if (!_focusTitle.hasFocus) {
        cursorTitle = titleController.selection.base.offset;
      }
    });
    super.initState();
    if (mounted) {
      searchInterestSets = BlocProvider.of<GraphqlBloc>(context).interests;
      totalInterestSets = BlocProvider.of<GraphqlBloc>(context).interests;
      if (searchInterestSets.isEmpty) {
        BlocProvider.of<GraphqlBloc>(context).add(const ReadSkillsListEvent());
      }
      readUser();
    }
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (userPref != null) user = userPref;
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

  void searchData(String query) {
    BlocProvider.of<GraphqlBloc>(context).add(
      SearchSkillsListEvent(
        skills: totalInterestSets,
        query: query,
      ),
    );
  }

  Widget contents(BuildContext context) {
    String title = TitleString.titleSearchForInterest;
    String description = TitleString.warningNumberOfInterest;
    String titleSelectedSkills = TitleString.titleSearchForInterest;
    String buttonName = TitleString.btnSave;

    return BlocConsumer<GraphqlBloc, GraphqlState>(
      listener: (BuildContext context, state) {
        isLoading = false;

        switch (state.runtimeType) {
          case SkillsLoadingState:
            isLoading = true;
            break;
          case QueryUpdateSuccessState:
            break;
          case SkillsSearchSuccessState:
            searchInterestSets = (state as SkillsSearchSuccessState).list;
            break;
          case SkillsListReadSuccessState: // the same state is using to download interest. both are downloading in same query
            state as SkillsListReadSuccessState;
            setState(() {
              totalInterestSets = state.interests;
              searchInterestSets = state.interests;
              if (user != null && user?.personal_interests != null) {
                for (Interests item in user?.personal_interests ?? []) {
                  selectedItems.add(
                    Skills(
                      skill: item.interest ?? '',
                      id: item.sId,
                    ),
                  );
                }
              }
            });
            break;
          case SaveInterestListSuccessState:
            List<Interests> interests = [];
            state as SaveInterestListSuccessState;

            for (Skills itemSkills in state.interests) {
              interests.add(
                Interests(
                  sId: itemSkills.id,
                  sTypename: itemSkills.skill,
                  interest: itemSkills.skill,
                ),
              );
            }
            user?.personal_interests = interests;
            Locator.instance.get<UserRepo>().setCurrentUserData(user!);
            Navigator.pop(context, true);
            break;

          case GraphqlErrorState:
            print("Graphql error state: $state");
            break;
          default:
            print("Graphql Unknown state while logging in: $state");
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
          case SkillsSearchSuccessState:
            searchInterestSets = (state as SkillsSearchSuccessState).list;
            break;
          case GraphqlErrorState:
            print("Graphql error state: $state");
            break;
          default:
            print("Graphql Unknown state while logging in: $state");
        }
        return Container(
          padding: getPadding(left: 35, right: 35),
          height: size.height,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsSemiBold20,
                  ),
                  Container(
                    margin: getMargin(top: 12),
                    child: Text(
                      description,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsLight13,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: _focusTitle,
                    controller: titleController,
                    hintText: TitleString.startSearchingHint,
                    margin: getMargin(top: 18),
                    padding: TextFormFieldPadding.paddingV15H25,
                    textInputAction: TextInputAction.search,
                    variant: TextFormFieldVariant.outlineBlack90035,
                    // ?TODO poppins grey
                    hintStyle:
                        TextFormFieldFontStyle.poppinsRegular12WhiteA7007f,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    shape: TextFormFieldShape.roundedBorder50,
                    onChanged: (value) {
                      searchData(value.toLowerCase());
                    },
                    onSubmitted: (value) {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      searchData(value.toLowerCase());
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  if (!isLoading)
                    Container(
                      margin: getMargin(top: 24),
                      child: Text(
                        "${searchInterestSets.length} Results",
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLight13,
                      ),
                    ),
                  Container(
                    margin: getMargin(top: 17),
                    height: 326,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: searchInterestSets.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (isItemSelected(searchInterestSets[index])) {
                                  removeItemFromSelectedList(
                                      searchInterestSets[index]);
                                } else {
                                  if (selectedItems.length <
                                      maximumSelectableSkills) {
                                    selectedItems
                                        .add(searchInterestSets[index]);
                                  }
                                }
                                setState(() {});
                              },
                              child: SkillItem(
                                skill: searchInterestSets[index],
                                isSelected:
                                    isItemSelected(searchInterestSets[index]),
                                isLast: index == searchInterestSets.length - 1,
                                index: index,
                                length: selectedItems.length,
                                maxSelectLimit: maximumSelectableSkills,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleSelectedSkills,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium16WhiteA700,
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
                                style: AppStyle.txtPoppinsRegular11WhiteA700,
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
                        "Please select your skills to continue",
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLightItalic10,
                      ),
                    ),
                  if (selectedItems.isNotEmpty)
                    Container(
                      margin: getMargin(top: 16),
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
                                    selectedItems[index]);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  CustomButton(
                    // height: getVerticalSize(47),
                    text: buttonName,
                    enabled: selectedItems.isNotEmpty,
                    onTap: () {
                      if (selectedItems.isEmpty) {
                        showInfo(
                          context,
                          content: "Select at least one interest",
                          buttonLabel: TitleString.btnOkay,
                        );
                        return;
                      }
                      BlocProvider.of<GraphqlBloc>(context).add(
                        UpdateInterestListEvent(interests: selectedItems),
                      );
                    },
                    margin: getMargin(top: 30, bottom: 30),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
