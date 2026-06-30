import 'package:flutter/material.dart';

enum Tab { movies, restaurants, gadgets, books, games }

class TabUtils {
  static TabModel get(Tab tab) {
    switch (tab) {
      case Tab.movies:
        return TabModel(name: 'Movies', color: const Color(0xFF54B6E0));
      case Tab.restaurants:
        return TabModel(name: 'Restaurants', color: const Color(0xFFF9C74F));
      case Tab.gadgets:
        return TabModel(name: 'Gadgets', color: const Color(0xFFE45659));
      case Tab.books:
        return TabModel(name: 'Books', color: const Color(0xFFCDBBE9));
      case Tab.games:
        return TabModel(name: 'Games', color: const Color(0xFF90BE6D));
    }
  }

  static List<TabModel> getAll() {
    return Tab.values.map((tab) => get(tab)).toList();
  }
}

class TabModel {
  final String name;
  final Color color;

  TabModel({required this.name, required this.color});
}
