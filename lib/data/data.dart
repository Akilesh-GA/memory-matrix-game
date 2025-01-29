import 'package:memory_matrix/model/tile_model.dart';

List<TileModel> getPairs() {
  List<TileModel> pairs = [];
  List<String> assetPaths = [
    "assets/angular.png",
    "assets/dart.png",
    "assets/react.png",
    "assets/flutter.png",
    "assets/nodejs.png",
    "assets/firebase.png",
    "assets/firestore.png",
    "assets/mongodb.png",
  ];

  for (String path in assetPaths) {
    TileModel tileModel = TileModel(imageAssetPath: path, isSelected: false);
    pairs.add(tileModel);
  }

  return pairs;
}

List<TileModel> getQuestions() {
  List<TileModel> pairs = [];

  for (int i = 0; i < 16; i++) {
    TileModel tileModel = TileModel(imageAssetPath: "assets/questionmark.png", isSelected: false);
    pairs.add(tileModel);
  }

  return pairs;
}