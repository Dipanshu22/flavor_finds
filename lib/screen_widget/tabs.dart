import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flavor_finds/non_screen_widgets/main_drawer.dart';
import 'package:flavor_finds/screen_widget/categories.dart';
import 'package:flavor_finds/screen_widget/filters.dart';
import 'package:flavor_finds/screen_widget/meals.dart';
import 'package:flutter/material.dart';

import 'package:flavor_finds/providers/favorites_provide.dart';
import 'package:flavor_finds/providers/filters_provider.dart';



const initialFilters ={
  Filter.glutenFree:false,
  Filter.lactoseFree:false,
  Filter.veg:false,
  Filter.vegan:false,

};

class TabsScreen extends ConsumerStatefulWidget{
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  


  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async{
    Navigator.of(context).pop();
    if (identifier == 'filters') {
    await Navigator.of(context).push<Map<Filter,bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
      
      
    }
    
  }

  @override
  Widget build(BuildContext context) {
  
   final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
     
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
       
      );
      activePageTitle = 'Yours Favorite';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
            ),
          ]),
    );
  }
}
