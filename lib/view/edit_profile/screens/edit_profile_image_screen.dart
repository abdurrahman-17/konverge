import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utilities/title_string.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../core/app_export.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/file_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_icon_button.dart';
import '../../common_widgets/loader_with_logo.dart';
import '../../common_widgets/snack_bar.dart';

class EditProfileImageScreen extends StatefulWidget {
  static const String routeName = "/edit_profile_image";

  const EditProfileImageScreen({
    super.key,
  });

  @override
  State<EditProfileImageScreen> createState() => _EditProfileImageScreenState();
}

class _EditProfileImageScreenState extends State<EditProfileImageScreen> {
  String? userId;
  bool fetch = false;

  // Future<void> fetchHeader() async {
  //   final query = await AmplifyService().getTokens();ry!.idToken} }");
  // }
  bool isLoading = true;
  String imagePath = "";
  bool profileUpdating = false;
  bool isSaveButtonEnabled = false;
  String profileImageUrl = "";
  UserInfoModel? user = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(UserInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    // fetchHeader();
    return Stack(
      children: [
        commonBackground,
        Container(
          //decoration: commonGradientBg,
          width: double.infinity,
          height: double.infinity,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: contents(context),
            appBar: CommonAppBar.appBar(context: context),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserImageSaveState) {
          if (state.status == ProviderStatus.loaded) {
            log("updates");
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                user?.profilePicUrlPath = state.key;
                Locator.instance.get<UserRepo>().setCurrentUserData(user);
                BlocProvider.of<GraphqlBloc>(context).add(
                  GraphqlInitialEvent(),
                );
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoginInitialEvent(),
                );
                Navigator.pop(context, state.key);
              });
            }
          }
        }
      },
      builder: (context, state) {
        isLoading = false;
        profileUpdating = false;
        if (state is UserImageUpdate) {
          if (state.status == ProviderStatus.loading) {
            isLoading = true;
          } else if (state.status == ProviderStatus.loaded) {
            isLoading = false;
            imagePath = state.filePath;
            profileImageUrl = "";
          }
        } else if (state is FetchUserImageUrlState) {
          if (state.status == ProviderStatus.loading) {
            isLoading = true;
          } else if (state.status == ProviderStatus.loaded) {
            isLoading = false;
            profileImageUrl = state.fileUrl;
            // currentUser.profileImageUrl = state.fileUrl;
          } else {
            isLoading = false;
          }
        } else if (state is UserImageSaveState) {
          if (state.status == ProviderStatus.loading) {
            profileUpdating = true;
          } else if (state.status == ProviderStatus.loaded) {
            profileUpdating = false;
            log("updates");
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                BlocProvider.of<GraphqlBloc>(context).add(
                  GraphqlInitialEvent(),
                );
                Navigator.pop(context, state.key);
              });
            }
          } else if (state.status == ProviderStatus.error) {
            profileUpdating = false;
          }
        }
        return Container(
          padding: getPadding(left: 35, right: 35, bottom: 40),
          width: size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TitleString.titleProfilePicScreen,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtPoppinsMedium19,
              ),
              Container(
                width: getHorizontalSize(282),
                margin: getMargin(top: 11, bottom: 45),
                child: Text(
                  "Upload a profile picture from your photos to show people who you are!",
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsLight13,
                ),
              ),
              Align(
                child: profileImageWidget(context),
              ),
              const Spacer(),
              CustomButton(
                text: "Save",
                enabled: isSaveButtonEnabled,
                onTap: isSaveButtonEnabled
                    ? () async {
                        if (imagePath.isEmpty) {
                          showSnackBar(
                            message: "Please select an Image",
                          );
                        } else {
                          setState(() {
                            isSaveButtonEnabled = false;
                          });
                          final activeUser = Locator.instance
                              .get<UserRepo>()
                              .getCurrentUserData();
                          userId ??= activeUser?.userId;
                          BlocProvider.of<UserBloc>(context).add(
                            SaveProfileImageEvent(
                              imageFile: File(imagePath),
                              userId: userId ?? "",
                            ),
                          );
                        }
                      }
                    : null,
              )
            ],
          ),
        );
      },
    );
  }

  Widget profileImageWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        updateImage(context: context);
      },
      child: SizedBox(
        height: getSize(140),
        width: getSize(134),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: getSize(134),
                width: getSize(134),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  color: AppColors.black900Cc,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getHorizontalSize(67)),
                  ),
                  child: Container(
                    height: getSize(134),
                    width: getSize(134),
                    // padding:
                    //     getPadding(left: 37, top: 40, right: 37, bottom: 40),
                    decoration: AppDecoration.fillBlack900cc.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder67,
                    ),
                    child: Center(
                      child: isLoading
                          ? Container(
                              padding: getPadding(all: 20),
                              child: LoaderWithLogo())
                          : imagePath.isNotEmpty
                              ? CustomLogo(
                                  file: File(imagePath),
                                  height: getSize(134),
                                  width: getSize(134),
                                )
                              : (user?.profilePicUrlPath ?? '').isNotEmpty
                                  ? CustomLogo(
                                      url: Constants.getProfileUrl(
                                        user?.profilePicUrlPath ?? '',
                                      ),
                                      height: getSize(134),
                                      width: getSize(134),
                                    )
                                  : Container(
                                      margin: getPadding(
                                        left: 37,
                                        top: 40,
                                        right: 37,
                                        bottom: 40,
                                      ),
                                      child: CustomLogo(
                                        svgPath: Assets.imgUserTealA400,
                                        height: getVerticalSize(54),
                                        width: getHorizontalSize(58),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: getHorizontalSize(29),
                height: getVerticalSize(29),
                child: CustomIconButton(
                  height: 29,
                  width: 29,
                  variant: IconButtonVariant.fillTeal300,
                  shape: IconButtonShape.roundedBorder14,
                  alignment: Alignment.topCenter,
                  child: CustomLogo(
                    svgPath: Assets.imgCamera,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateImage({required BuildContext context}) async {
    ///camera or gallery bottom sheet
    ImageSource? imageSource = await showSelectPhotoOptions(context);

    if (imageSource != null) {
      ///image picker
      String? filePath = await imagePicker(imageSource: imageSource);

      if (filePath != null) {
        if (getFileSizeInMB(filePath) <= Constants.fileLimit) {
          CroppedFile? croppedFile = await imageCropper(
            context,
            filePath: filePath,
          );

          ///image cropper
          if (croppedFile != null) {
            imagePath = croppedFile.path;
            setState(() {
              isSaveButtonEnabled = true;
            });
            BlocProvider.of<UserBloc>(context).add(
              UpdateProfileImageEvent(
                imageFile: File(imagePath),
              ),
            );
          }
        } else {
          showSnackBar(
            message: "File size should be less than ${Constants.fileLimit} MB",
          );
        }
      }
    }
  }
}
