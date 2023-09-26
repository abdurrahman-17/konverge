import 'package:flutter/material.dart';
import '../../../../utilities/title_string.dart';
import '../../../../blocs/search_user/search_user_bloc.dart';
import '../../../../core/configurations.dart';
import '../../../../core/locator.dart';
import '../../../../models/graphql/user_info.dart';
import '../../../../repository/user_repository.dart';
import '../../../../theme/app_style.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/enums.dart';
import '../../../../utilities/size_utils.dart';
import '../../../common_widgets/custom_textfield.dart';
import '../../../common_widgets/loader_with_logo.dart';
import '../../../search_for_skills/screens/search_for_skills.dart';
import '../../../view_profile/screens/view_profile_screen.dart';
import '../../widgets/search/recent_search_item.dart';
import '../../widgets/search/search_item.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'search_screen/';

  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusSearch = FocusNode();
  late int cursorSearch = 0;
  bool firstTime = false;
  String searchText = "";
  int minCharCount = 3;
  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  void initState() {
    _focusSearch.addListener(() {
      if (!_focusSearch.hasFocus) {
        cursorSearch = searchController.selection.base.offset;
      }
    });
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkLookingForSkillsUpdated());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkLookingForSkillsUpdated() async {
    if (activeUser?.looking_for_skills == null ||
        activeUser!.looking_for_skills!.isEmpty) {
      var isSkillsUpdated = await Navigator.pushNamed(
        context,
        SearchForSkillsScreen.routeName,
        arguments: {
          'isSecondTime': true,
        },
      );
      if (isSkillsUpdated != null) {}
    }
  }

  bool clicked = false;

  bool initial = false;

  List<UserInfoModel> fetchedUsers = [];

  List<UserInfoModel> recentUsers = [];

  void searchUsers(String query) {
    BlocProvider.of<SearchUserBloc>(context).add(
      FetchSearchUsersEvent(query: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: SingleChildScrollView(
        child: Container(
          //height: getVerticalSize(872),
          width: double.maxFinite,
          padding: getPadding(
            left: 35,
            right: 35,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                focusNode: _focusSearch,
                controller: searchController,
                hintText: "Start Searching",
                margin: getMargin(top: 27),
                onChanged: (query) {
                  firstTime = true;
                  if (query.length >= minCharCount) {
                    searchUsers(query);
                  } else {
                    setState(() {
                      fetchedUsers = [];
                    });
                  }
                  searchText = query;
                },
                validator: null,
                variant: TextFormFieldVariant.outlineBlack90035,
                padding: TextFormFieldPadding.paddingT13,
                shape: TextFormFieldShape.roundedBorder50,
                fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                textInputAction: TextInputAction.done,
              ),
              searchBlocData()
            ],
          ),
        ),
      ),
    );
  }

  bool loading = false;

  Widget searchBlocData() {
    return BlocBuilder<SearchUserBloc, SearchUserState>(
      builder: (context, state) {
        loading = false;

        if (state is FetchSearchUsersState) {
          if (state.recentUsers.isNotEmpty) {
            recentUsers = state.recentUsers;
          }
          if (state.status == ProviderStatus.loading) {
            loading = true;
          } else if (state.status == ProviderStatus.loaded) {
            fetchedUsers = state.users;

            if (searchText.length < minCharCount) {
              fetchedUsers = [];
            }
          }
        } else if (state is RecentSearchState) {
          recentUsers = state.users;
        } else {}

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: recentUsers.isNotEmpty,
                  child: Padding(
                    padding: getPadding(top: 14, bottom: 14),
                    child: Text(
                      "Recent searches",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsLight13WhiteA700,
                    ),
                  ),
                ),
                Visibility(
                  visible: recentUsers.isNotEmpty,
                  child: SizedBox(
                    height: getVerticalSize(75),
                    child: ListView.separated(
                      //physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: getVerticalSize(10),
                        );
                      },
                      itemCount: recentUsers.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            _focusSearch.unfocus();
                            BlocProvider.of<SearchUserBloc>(context).add(
                              AddToRecentSearchEvent(user: recentUsers[index]),
                            );
                            await Navigator.pushNamed(
                              context,
                              ViewProfileScreen.routeName,
                              arguments: {
                                'cognitoId': recentUsers[index].cognitoId,
                                "from": "search",
                                "current": activeUser?.userId,
                                "userId": recentUsers[index].userId
                              },
                            );
                          },
                          child: RecentSearchItem(
                            user: recentUsers[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: recentUsers.isNotEmpty,
                  child: Padding(
                    padding: getPadding(top: 19),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: AppColors.blueGray700,
                    ),
                  ),
                ),
                fetchedUsers.isEmpty
                    ? SizedBox(height: 35)
                    : Container(
                        padding: getPadding(top: 13),
                        width: double.maxFinite,
                        margin: getMargin(right: 5),
                        child: Text(
                          fetchedUsers.length == 1
                              ? "${fetchedUsers.length} Result"
                              : "${fetchedUsers.length} Results",
                          overflow: TextOverflow.ellipsis,
                          // Aligns the text to the right
                          textAlign: TextAlign.right,
                          style: AppStyle.txtPoppinsLight13WhiteA700,
                        ),
                      ),
                loading
                    ? SizedBox.shrink()
                    : fetchedUsers.isNotEmpty
                        ? ListView.builder(
                            itemCount: fetchedUsers.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  _focusSearch.unfocus();
                                  BlocProvider.of<SearchUserBloc>(context).add(
                                    AddToRecentSearchEvent(
                                      user: fetchedUsers[index],
                                    ),
                                  );
                                  await Navigator.pushNamed(
                                    context,
                                    ViewProfileScreen.routeName,
                                    arguments: {
                                      'cognitoId':
                                          fetchedUsers[index].cognitoId,
                                      "from": "search",
                                      "current": activeUser?.userId,
                                      "userId": fetchedUsers[index].userId,
                                    },
                                  );
                                },
                                child: SearchItem(
                                  userIndex: index,
                                  user: fetchedUsers[index],
                                ),
                              );
                            },
                          )
                        : Visibility(
                            visible: searchText.length >= 3 &&
                                fetchedUsers.length <= 0,
                            child: Center(
                              child: Container(
                                padding: getPadding(top: 100),
                                child: Text(
                                  TitleString.warningNoDataSearchResult,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: AppStyle.txtPoppinsBoldItalic20,
                                ),
                              ),
                            ),
                          ),
                if (searchText.length < minCharCount)
                  Center(
                    child: Container(
                      padding: getPadding(top: 100),
                      child: Text(
                        TitleString.warningEmptySearchBox,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppStyle.txtPoppinsItalic14,
                      ),
                    ),
                  ),
              ],
            ),
            loading
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: getMargin(top: _focusSearch.hasFocus ? 130 : 260),
                      height: getSize(50),
                      width: getSize(50),
                      child: LoaderWithLogo(),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
