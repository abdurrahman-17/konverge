import 'package:flutter/material.dart';
import '../../../../repository/user_repository.dart';
import '../../../../blocs/graphql/graphql_bloc.dart';
import '../../../../blocs/graphql/graphql_state.dart';
import '../../../../core/app_export.dart';
import '../../../../core/configurations.dart';
import '../../../../core/locator.dart';
import '../../../../models/graphql/user_info.dart';
import '../../widgets/profile/profile_view.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, this.onTapProfile});

  final VoidCallback? onTapProfile;
  static const String routeName = 'profile/';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  UserInfoModel? user;

  @override
  void initState() {
    super.initState();
    readUser();
  }

  Future<void> getData() async {
    // final path =
    //     await AmplifyService().getStoragePath(currentUser.profileImage ?? "");
    // if (path[0].isNotEmpty) {
    //   setState(() {
    //     currentUser.profileImageUrl = path[0];
    //   });
    // }
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (userPref != null) user = userPref;
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return contents(context);
  }

  Widget contents(BuildContext context) {
    // if (user != null) {
    //   currentUser = User.fromUserInfoModel(user!);
    //   getData();
    // }

    var activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    return SizedBox(
      width: size.width,
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: BlocConsumer<GraphqlBloc, GraphqlState>(
            listener: (BuildContext context, state) {
              switch (state.runtimeType) {
                case QueryLoadingState:
                  break;
                case GraphqlErrorState:
                  print("Graphql error state: $state");
                  break;
                default:
                  setState(() {});
                  print("Graphql Unknown state while edit profile: $state");
              }
            },
            builder: (context, state) {
              if (state is GraphqlInitialState) {
                activeUser =
                    Locator.instance.get<UserRepo>().getCurrentUserData();
                print("stet");
              }
              return ProfileView(
                user: activeUser,
                onTapProfile: widget.onTapProfile,
                from: "profile",
              );
            },
          ),
        ),
      ),
    );
  }
}
