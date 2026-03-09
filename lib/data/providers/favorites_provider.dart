import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nestify/data/models/property_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<PropertyModel> _favorites = [];
  static const String _storageKey = 'favorites';

  List<PropertyModel> get favorites => List.unmodifiable(_favorites);

  int get favoritesCount => _favorites.length;

  bool isFavorite(String propertyId) {
    return _favorites.any((property) => property.id == propertyId);
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_storageKey) ?? [];
      
      _favorites.clear();
      for (final jsonString in favoritesJson) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        _favorites.add(PropertyModel.fromJson(json));
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(PropertyModel property) async {
    if (isFavorite(property.id)) {
      await removeFavorite(property.id);
    } else {
      await addFavorite(property);
    }
  }

  Future<void> addFavorite(PropertyModel property) async {
    if (!isFavorite(property.id)) {
      _favorites.add(property);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String propertyId) async {
    _favorites.removeWhere((property) => property.id == propertyId);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favorites
          .map((property) => jsonEncode(property.toJson()))
          .toList();
      await prefs.setStringList(_storageKey, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }
}
