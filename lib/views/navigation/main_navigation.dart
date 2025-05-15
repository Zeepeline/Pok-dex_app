import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/views/home/home_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: HomePage(title: 'Home Page')),
    Center(child: Text('Search Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        selectedLabelStyle: AppTextStyles.label.copyWith(
          color: Color(0xFF173EA5),
        ),
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/unselected_pokeball.svg'),
              activeIcon:
                  SvgPicture.asset('assets/icons/selected_pokeball.svg'),
              label: 'Pokedéx'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/unselected_favorite.svg'),
              activeIcon:
                  SvgPicture.asset('assets/icons/selected_favorite.svg'),
              label: 'Favorite'),
        ],
      ),
    );
  }
}
