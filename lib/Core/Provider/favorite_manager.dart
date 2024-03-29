import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pokemonapp/Core/Hive/favorite_object.dart';

class FavoriteManager extends ChangeNotifier {
  FavoriteManager(this._favorites);

  List<FavoriteObject> _favorites = [];

  List<FavoriteObject> get favorites => _favorites;

  Future<void> addItem(FavoriteObject item) async {
    final favoritesHive = getBox();
    await favoritesHive.add(item);
    _favorites.add(item);
    notifyListeners();
  }

  Future<void> removeItem(FavoriteObject item) async {
    final favoritesHive = getBox();
    //To get the key of the item for deletion in Hive package
    final Map<dynamic, FavoriteObject> favoritesMap = favoritesHive.toMap();
    dynamic desiredKey;
    favoritesMap.forEach((key, value) {
      if (value.name == item.name && value.url == item.url) desiredKey = key;
    });
    await favoritesHive.delete(desiredKey);
    //check list item and remove
    _favorites.removeWhere(
        (value) => value.name == item.name && value.url == item.url);
    notifyListeners();
  }

  bool checkContainList(FavoriteObject item) {
    if (_favorites.any((e) => e.name == item.name || e.url == item.url)) {
      return true;
    } else {
      return false;
    }
  }

  Box<FavoriteObject> getBox() {
    Box<FavoriteObject> box = Hive.box<FavoriteObject>('favorites');
    return box;
  }

  // searchFavoritesItem(String searchValue) {
  //   var searchArray = searchValue.split(" ");
  //   _favoritesTemp.clear();
  //   _favoritesTemp = List.of(_favorites);
  //   String text = "";
  //   for (var i = 0; i < _favorites.length; i++) {
  //     text = _favorites[i].name.toString();
  //     var ok = true;
  //     for (int i2 = 0; i2 < searchArray.length; i2++) {
  //       if (searchArray[i2] != "" && !text.contains(searchArray[i2])) {
  //         ok = false;
  //         break;
  //       }
  //     }
  //     if (ok) {
  //       _favoritesTemp.add(_favorites[i]);
  //     }
  //   }
  //   notifyListeners();
  // }
}
