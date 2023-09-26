import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../utilities/transition_constant.dart';
import '../../../core/app_export.dart';
import '../../../core/locator.dart';
import '../../../repository/user_repository.dart';
import '../../../services/comet_chat.dart';
import '../../../utilities/common_design_utils.dart';
import '../../../utilities/enums.dart';
import '../../../models/graphql/user_info.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/profile_imageItem.dart';
import '../../launch/screens/launch_screen.dart';

class ItsMatchScreen extends StatefulWidget {
  static const String routeName = "/its_match";
  final UserInfoModel matchUser;

  ItsMatchScreen({
    super.key,
    required this.matchUser,
  });

  @override
  State<ItsMatchScreen> createState() => _ItsMatchScreenState();
}

class _ItsMatchScreenState extends State<ItsMatchScreen>
    with TickerProviderStateMixin {
  bool startAnimation = false;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        // CommonBgLogo(
        //   opacity: 0.6,
        //   position: CommonBgLogoPosition.center,
        // ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: contents(context),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    return Stack(
      children: [
        Center(
          child: Lottie.asset(
            'assets/images/lottie_files/blueConfetti.json',
            controller: _controller,
            repeat: false,
            onLoaded: (composition) {
              _controller!
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
        Container(
          width: size.width,
          margin: getMargin(left: 35, right: 35),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: getPadding(top: 7),
                child: Text(
                  "It's a match!",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyle.txtPoppinsMedium20,
                ),
              ),
              Padding(
                padding: getPadding(top: 9),
                child: Text(
                  "We've found you a great potential\nbusiness partner.",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyle.txtPoppinsRegular14WhiteA700,
                ),
              ),
              Container(
                width: getHorizontalSize(279),
                margin: getMargin(top: 97),
                height: getVerticalSize(227),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: CustomLogo(
                        height: getVerticalSize(227),
                        width: getHorizontalSize(236),
                        imagePath: Assets.commonLogo,
                        fit: BoxFit.contain,
                        opacity: 0.3,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProfileImageItem(
                                  matchData: getColorCodeFromPersonalityCode(
                                    activeUser?.my_code ?? '',
                                    90,
                                  ),
                                  height: getSize(115),
                                  child: profileImageWidget(activeUser!)),
                              Container(
                                padding: getMargin(top: 8),
                                width: getHorizontalSize(130),
                                child: Text(
                                  activeUser.fullname ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: AppStyle.txtPoppinsSemiBold13,
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProfileImageItem(
                                matchData: getColorCodeFromPersonalityCode(
                                  widget.matchUser.my_code ?? '',
                                  90,
                                ),
                                height: getSize(115),
                                child: profileImageWidget(widget.matchUser),
                              ),
                              Container(
                                padding: getMargin(top: 8),
                                width: getHorizontalSize(130),
                                child: Text(
                                  "${widget.matchUser.fullname}",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: AppStyle.txtPoppinsSemiBold13,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AnimatedContainer(
                duration: Duration(
                    milliseconds:
                        TransitionConstant.itsMatchTransitionDuration),
                curve: Curves.easeIn,
                transform: Matrix4.translationValues(0,
                    startAnimation ? 0 : MediaQuery.of(context).size.height, 0),
                child: Column(
                  children: [
                    CustomButton(
                      // height: getVerticalSize(47),
                      text: "Send Message",
                      margin: getMargin(top: 20),
                      enabled: true,
                      fontStyle: ButtonFontStyle.poppinsRegular14,
                      onTap: () {
                        HapticFeedback.vibrate();
                        cometChatRedirections(
                            context, widget.matchUser.userId ?? "");
                      },
                    ),
                    CustomButton(
                      // height: getVerticalSize(47),
                      text: "Keep matching",
                      margin: getMargin(top: 20, bottom: 71),
                      variant: ButtonVariant.outlineTealA400,
                      fontStyle: ButtonFontStyle.poppinsRegular14WhiteA700,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LaunchScreen.routeName,
                          arguments: {
                            'tab': 1,
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget profileImageWidget(UserInfoModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          color: AppColors.black9004c,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getHorizontalSize(52)),
          ),
          child: Container(
            height: getSize(90),
            width: getSize(90),
            decoration: AppDecoration.fillBlack900
                .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
            child: user.profilePicUrlPath != null &&
                    user.profilePicUrlPath != ""
                ? CustomLogo(
                    url: Constants.getProfileUrl(user.profilePicUrlPath ?? ''),
                    height: getSize(90),
                    width: getSize(90),
                    alignment: Alignment.topCenter,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: getPadding(all: 29),
                        height: getSize(90),
                        width: getSize(90),
                        child: CustomLogo(
                          svgPath: Assets.imgUserTealA400,
                          height: getVerticalSize(39),
                          width: getHorizontalSize(46),
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
