class TileModel {
  String imageAssetPath;
  bool isSelected;

  TileModel({required this.imageAssetPath, required this.isSelected});

  void setAssetPath(String path) {
    imageAssetPath = path;
  }

  void setSelected(bool selected) {
    isSelected = selected;
  }

  String get image => imageAssetPath;

  bool get selected => isSelected;

  // Add the getImageAssetPath method
  String getImageAssetPath() {
    return imageAssetPath;
  }

  // Add the getIsSelected method
  bool getIsSelected() {
    return isSelected;
  }
}
