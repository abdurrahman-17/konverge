class ProfileVisibleData {
  String name;
  bool visibility;
  bool toggleShow;

ProfileVisibleData({
    required this.name,
    this.visibility = false,
    this.toggleShow = true,
  });
}
