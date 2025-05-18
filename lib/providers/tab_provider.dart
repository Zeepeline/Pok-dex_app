import 'package:flutter/material.dart';

class TabProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
