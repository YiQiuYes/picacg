import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/pages/category/category_page.dart';
import 'package:picacg/pages/game/game_page.dart';
import 'package:picacg/pages/home/home_page.dart';
import 'package:picacg/pages/main/main_store.dart';
import 'package:picacg/pages/person/person_page.dart';
import 'package:picacg/widgets/responsive_widget.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> with MainStore {
  @override
  Widget build(BuildContext context) {
    init(ref);

    return Scaffold(
      body: Row(
        children: [
          ResponsiveWidget(
            tablet: _getRailNavigationWidget(),
            folded: SizedBox(),
            foldedLandscape: _getRailNavigationWidget(),
          ),
          Expanded(child: _getBodyWidget()),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget(
        mobile: _getBottomNavigationBarWidget(),
        folded: _getBottomNavigationBarWidget(),
        foldedLandscape: SizedBox(),
      ),
    );
  }

  Widget _getBodyWidget() {
    return PageView(
      controller: pageController,
      scrollDirection: ResponsiveWidget.of(
        context,
        mobile: Axis.horizontal,
        folded: Axis.horizontal,
        foldedLandscape: Axis.vertical,
        tablet: Axis.vertical,
      ),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const HomePage(),
        const CategoryPage(),
        const GamePage(),
        const PersonPage(),
      ],
    );
  }

  Widget _getRailNavigationWidget() {
    return NavigationRail(
      selectedIndex: ref.watch(navigationIndexProvider),
      onDestinationSelected: (index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        ref.read(navigationIndexProvider.notifier).state = index;
      },
      labelType: NavigationRailLabelType.selected,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: Text(
            Language.of(context).home,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category_rounded),
          label: Text(
            Language.of(context).category,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.gamepad_outlined),
          selectedIcon: Icon(Icons.gamepad_rounded),
          label: Text(
            Language.of(context).game,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person_rounded),
          label: Text(
            Language.of(context).personal,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _getBottomNavigationBarWidget() {
    return NavigationBar(
      selectedIndex: ref.watch(navigationIndexProvider),
      onDestinationSelected: (index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        ref.read(navigationIndexProvider.notifier).state = index;
      },
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: Language.of(context).home,
        ),
        NavigationDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category_rounded),
          label: Language.of(context).category,
        ),
        NavigationDestination(
          icon: Icon(Icons.gamepad_outlined),
          selectedIcon: Icon(Icons.gamepad_rounded),
          label: Language.of(context).game,
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person_rounded),
          label: Language.of(context).personal,
        ),
      ],
    );
  }
}
