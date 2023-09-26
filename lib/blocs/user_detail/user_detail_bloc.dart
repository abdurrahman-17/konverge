import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/app_export.dart';
import '../../models/graphql/user_info.dart';
import '../../services/api_requests/api_service.dart';
import '../../core/locator.dart';
import '../../repository/graphql_repo.dart';
import '../../repository/user_repository.dart';
import '../../services/amplify/amplify_service.dart';
import '../../utilities/enums.dart';

part 'user_detail_event.dart';

part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  // UserModel? currentUser;
  AmplifyService amplifyService = AmplifyService();

  UserDetailBloc() : super(UserDetailInitialState()) {
    on<UserDetailInitialEvent>((event, emit) {
      emit(UserDetailInitialState());
    });

    /*fetching user data from DB*/
    // on<GetUserDataEvent>((event, emit) async {
    //   if (event.userId.isNotEmpty) {
    //     currentUser = await Locator.instance
    //         .get<FirebaseServices>()
    //         .getUserData(event.userId);
    //     if (currentUser != null) {
    //       emit(UserFoundState(currentUser!));
    //     } else {
    //       emit(UserNotFound());
    //     }
    //   } else {
    //     emit(UserNotFound());
    //   }
    // });

    /*saving user data*/
    // on<SaveUserDataEvent>((event, emit) async {
    //   bool isSuccess = await Locator.instance
    //       .get<FirebaseServices>()
    //       .createUserAccount(event.user);
    //   if (isSuccess) {
    //     emit(UserDataSavedState());
    //   } else {
    //     emit(UserNotFound());
    //   }
    // });

    /*updating profile image*/
    on<UpdateProfileImageEvent>((event, emit) async {
      emit(
        const UserImageUpdate(
          status: ProviderStatus.loading,
          filePath: "",
        ),
      );
      emit(
        UserImageUpdate(
          status: ProviderStatus.loaded,
          filePath: event.imageFile.path,
        ),
      );
    });
    /*For updating last login date stamp to server*/
    on<UserLastLoginTimeUpdateEvent>((event, emit) async {
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateLoginTimeToDb(userId: event.userId);
      result.fold(
          (error) => {
                emit(UserLastLoginTimeUpdateState(error.message.toString(),
                    successStatus: false))
              },
          (success) => {
                emit(
                    const UserLastLoginTimeUpdateState("", successStatus: true))
              });
    });

    /*updating profile image*/
    on<SaveProfileImageEvent>(
      (event, emit) async {
        emit(const UserImageUpdate(
            status: ProviderStatus.loading, filePath: ""));
        final String name = event.imageFile.path.split('_').last;
        final String fileName = "profile/${event.userId}/$name";

        final String? urlPath =
            await Locator.instance.get<ApiService>().uploadProfilePic(
                  file: event.imageFile,
                  fileName: fileName,
                  fileSize: event.imageFile.lengthSync(),
                  userId: event.userId,
                );

        if (urlPath != null) {
          final activeUser =
              Locator.instance.get<UserRepo>().getCurrentUserData();
          //Save url to
          var result = await Locator.instance
              .get<GraphqlRepo>()
              .updateProfilePictureUrl(activeUser!.userId!, urlPath);

          result.fold(
            (error) {
              emit(
                UserImageSaveState(
                  status: ProviderStatus.error,
                  fileUri: "",
                  error: error.message,
                  key: "",
                ),
              );
            },
            (success) {
              activeUser.profilePicUrlPath = urlPath;
              // activeUser.profileImageUrl = url,
              Locator.instance.get<UserRepo>().setCurrentUserData(activeUser);
              emit(
                UserImageSaveState(
                  status: ProviderStatus.loaded,
                  fileUri: '',
                  error: "",
                  key: urlPath,
                ),
              );
            },
          );
          //URL save done.
        } else {
          emit(
            UserImageSaveState(
              status: ProviderStatus.error,
              fileUri: "",
              error: "File upload error",
              key: "",
            ),
          );
        }
      },
    );

    /*fetchUserImage*/
    on<FetchProfileImageUrl>(
      (event, emit) async {
        emit(const FetchUserImageUrlState(
            status: ProviderStatus.loading, fileUrl: "", error: ""));
        final filePath = await Locator.instance
            .get<AmplifyService>()
            .getStoragePath(event.key);
        if (filePath.isNotEmpty) {
          emit(
            FetchUserImageUrlState(
              status: ProviderStatus.loaded,
              fileUrl: filePath[0],
              error: filePath[1],
            ),
          );
          //URL save done.
        } else {
          emit(
            FetchUserImageUrlState(
              status: ProviderStatus.error,
              fileUrl: filePath[0],
              error: filePath[1],
            ),
          );
        }
      },
    );
    on<FetchUserDetailEvent>(
      (event, emit) async {
        emit(
          const FetchUserDetailState(
            status: ProviderStatus.loading,
            user: null,
            error: "",
          ),
        );
        String cognitoId = event.cognitoId;
        var result = await Locator.instance.get<GraphqlRepo>().readUserDetails(
              cognitoId,
              searchId: event.searchId,
              userId: event.userId,
            );

        result.fold(
          (error) => {
            emit(
              FetchUserDetailState(
                status: ProviderStatus.error,
                user: null,
                error: error.message,
              ),
            ),
          },
          (success) => {
            emit(
              FetchUserDetailState(
                status: ProviderStatus.loaded,
                user: success,
                error: "",
              ),
            ),
          },
        );
      },
    );
    /*match user event*/
    on<MatchUserDetailEvent>(
      (event, emit) async {
        emit(
          UserMatchedSuccessState(
            status: ProviderStatus.loading,
            error: "",
            user: event.user,
            itsMatch: false,
            isMatch: false,
          ),
        );
        var result = await Locator.instance.get<GraphqlRepo>().matchUser(
              userId: event.userId,
              interestedId: event.user.userId!,
              isMatch: event.isMatch,
              matchType: event.matchType,
            );
        emit(UserDetailInitialState());
        result.fold(
          (error) {
            emit(
              UserMatchedSuccessState(
                status: ProviderStatus.error,
                error: error.message,
                user: event.user,
                itsMatch: false,
                isMatch: event.isMatch,
              ),
            );
          },
          (success) {
            emit(
              UserMatchedSuccessState(
                status: ProviderStatus.loaded,
                error: success.message,
                user: event.user,
                itsMatch: success.itsMatch,
                isMatch: event.isMatch,
              ),
            );
          },
        );
      },
    );
    /*Block user*/
    on<BlockUserDetailEvent>((event, emit) async {
      emit(const UserBlockedSuccessState(
          error: "", status: ProviderStatus.loading));
      DateTime date = DateTime.now();

      String time = getFormattedDate(date, "dd/MM/yyyy");
      var result = await Locator.instance.get<GraphqlRepo>().blockUser(
          userId: event.userId, interestId: event.interestedId, time: time);
      log("result $result");
      emit(UserDetailInitialState());
      result.fold(
          (error) => {
                emit(UserBlockedSuccessState(
                    error: error.message, status: ProviderStatus.error))
              },
          (success) => {
                emit(const UserBlockedSuccessState(
                    error: "", status: ProviderStatus.loaded))
              });
    });

    /*Un Block user*/
    on<UnblockUserDetailEvent>((event, emit) async {
      emit(const UserUnBlockedSuccessState(
          error: "", status: ProviderStatus.loading));
      DateTime date = DateTime.now();

      String time = getFormattedDate(date, "dd/MM/yyyy");
      var result = await Locator.instance.get<GraphqlRepo>().unBlockUser(
          userId: event.userId, interestId: event.interestedId, time: time);
      emit(UserDetailInitialState());
      result.fold(
          (error) => {
                emit(UserUnBlockedSuccessState(
                    error: error.message, status: ProviderStatus.error))
              },
          (success) => {
                emit(const UserUnBlockedSuccessState(
                    error: "", status: ProviderStatus.loaded))
              });
    });

    /* user data save*/
    on<CreateUserAccountEvent>((event, emit) async {
      emit(const CreateUserAccountState(userCreateStatus: ApiStatus.loading));

      final result =
          await Locator.instance.get<UserRepo>().saveUserData(event.userData);
      final state = result.fold((l) {
        return CreateUserAccountState(
          userCreateStatus: ApiStatus.error,
          errorMessage: l.message,
        );
      }, (user) {
        return CreateUserAccountState(
          userCreateStatus: ApiStatus.success,
        );
      });
      emit(state);
    });

    /* DeleteUserAccountEvent*/
    on<DeleteUserAccountEvent>((event, emit) async {
      emit(const DeleteUserAccountState(userDeleteStatus: ApiStatus.loading));
      final result = await Locator.instance
          .get<UserRepo>()
          .deleteUserAccount(event.userId);
      final state = result.fold((l) {
        return DeleteUserAccountState(
          userDeleteStatus: ApiStatus.error,
          errorMessage: l.message,
        );
      }, (success) {
        return DeleteUserAccountState(
          userDeleteStatus: ApiStatus.success,
        );
      });
      emit(state);
    });
  }
}
