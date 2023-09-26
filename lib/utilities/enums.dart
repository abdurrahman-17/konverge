enum ImageUploadStatus {
  idle,
  uploading,
  uploaded,
  error,
}

enum ProviderStatus {
  idle,
  loading,
  loaded,
  error,
  search,
}

enum ApiCallType {
  get,
  post,
  delete,
  put,
  patch,
}

enum TextFormFieldPadding {
  paddingT1,
  paddingT13,
  paddingV12H15,
  paddingV15H25,
  paddingT36,
  paddingT36_1,
  paddingT10,
  paddingAll7,
  paddingSignUpTextField,
  paddingConfirmPassword,
  paddingT0,
}

enum TextFormFieldShape {
  roundedBorder23,
  roundedBorder12,
  roundedBorder8,
  roundedBorder3,
  roundedBorder14,
  roundedBorder50
}

enum TextFormFieldVariant {
  none,
  underLineGray40033,
  outlineBlack90035,
  outlineTealA400,
  outlineTealA400_1,
  outlineBlack90035_1,
  outlineBlueGray70001,
  outlineTealA400_2,
  fillBlack9007c,
  outlineBlack90035_2,
  outlineRedA4000_1,
  outlineBlack90035_3
}

enum TextFormFieldFontStyle {
  poppinsRegular12,
  poppinsMedium14,
  poppinsMedium14Disabled,
  poppinsMedium14WhiteA700,
  poppinsMedium14WhiteA700PasswordDot,
  poppinsMedium14Black900,
  poppinsLight13,
  poppinsLight14,
  poppinsRegular12WhiteA7007f,
  poppinsMedium13,
  poppinsLight14WhiteA700,
  poppinsRegular10,
  poppinsMedium14Error,
}

enum ButtonShape {
  square,
  roundedBorder23,
  roundedBorder16,
  roundedBorder8,
  roundedBorder13,
  roundedBorder26
}

enum ButtonPadding {
  paddingAll12,
  paddingT11,
  paddingH20,
  paddingAll9,
  paddingAll6,
  paddingAll0
}

enum ButtonVariant {
  transparent,
  outlineBlack90035_1,
  outlineBlack90035,
  fillWhiteA700,
  fillGray800,
  outlineTealA400,
  outlineTealA400_1,
  fillBlack9007c
}

enum ButtonFontStyle {
  poppinsRegular15,
  poppinsMedium16,
  poppinsLight10,
  poppinsRegular15WhiteA700,
  poppinsRegular15WhiteA400,
  poppinsRegular9,
  poppinsRegular14,
  poppinsRegular14WhiteA700,
}

enum CommonBgLogoPosition {
  topLeft,
  topCenter,
  topRight,
  bottomRight,
  bottomCenter,
  bottomLeft,
  center
}

enum IconButtonShape {
  circleBorder10,
  circleBorder32,
  roundedBorder14,
}

enum IconButtonPadding {
  paddingAll7,
  paddingAll24,
  paddingAll0,
  paddingV5H4,
}

enum IconButtonVariant {
  fillTealA700,
  fillTeal300,
  fillBlack9007c,
}

enum LoginType {
  usernameAndPassword,
  google,
  apple,
}

enum ApiStatus {
  idle,
  loading,
  success,
  error,
}

enum PageTransitionTypes { rightToLeft, bottomToTop }

enum ErrorType {
  normalWarning,
  dialogWarning,
  snackBarWarning,
}
