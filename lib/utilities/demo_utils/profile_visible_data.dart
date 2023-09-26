import '../../core/app_export.dart';

import '../../models/design_models/profile_visible_data.dart';

List<ProfileVisibleData> profileVisible = [
  ProfileVisibleData(
    name: Constants.editProfilePicture,
    visibility: true,
  ),
  ProfileVisibleData(
    name: Constants.editProfileBiography,
    visibility: true,
  ),
  ProfileVisibleData(
    name: Constants.editProfileSkills,
    visibility: true,
    toggleShow: false,
  ),
  ProfileVisibleData(
    name: Constants.editProfileQualities,
    visibility: true,
    toggleShow: false,
  ),
  ProfileVisibleData(
    name: Constants.editProfileSkillsLookingFor,
    visibility: true,
  ),
  ProfileVisibleData(
    name: Constants.editProfileBusinessIdea,
    visibility: true,
    toggleShow: false,
  ),
  ProfileVisibleData(
    name: Constants.editProfileMotivation,
    visibility: true,
  ),
  ProfileVisibleData(
    name: Constants.editProfilePassion,
    visibility: true,
  ),
  ProfileVisibleData(
    name: Constants.editProfileInterests,
    visibility: true,
  ),
  ProfileVisibleData(
    name: Constants.editProfileHoursPerWeek,
    visibility: true,
  ),
];
