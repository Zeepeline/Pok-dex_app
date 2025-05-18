import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/providers/tab_provider.dart';
import 'package:pokedex_app/views/favorite/favorite_pokemon_page.dart';
import 'package:pokedex_app/views/home/home_page.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late PageController _pageController;
  late TabProvider _tabProvider;

  final List<Widget> _pages = const [
    Center(child: HomePage()),
    Center(child: FavoritePokemonPage()),
  ];

  @override
  void initState() {
    super.initState();
    _tabProvider = context.read<TabProvider>();
    _pageController = PageController(initialPage: _tabProvider.selectedIndex);
    _tabProvider.addListener(() {
      final newIndex = _tabProvider.selectedIndex;
      if (_pageController.hasClients &&
          _pageController.page?.round() != newIndex) {
        _pageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    _tabProvider.setTab(index);
  }

  void _onPageChanged(int index) {
    _tabProvider.setTab(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<TabProvider>().selectedIndex;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: false,
          selectedLabelStyle: AppTextStyles.label.copyWith(
            color: const Color(0xFF173EA5),
            height: 2,
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/unselected_pokeball.svg'),
              activeIcon:
                  SvgPicture.asset('assets/icons/selected_pokeball.svg'),
              label: 'Pokedéx',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/unselected_favorite.svg'),
              activeIcon:
                  SvgPicture.asset('assets/icons/selected_favorite.svg'),
              label: 'Favorite',
            ),
          ],
        ),
      ),
    );
  }
}
