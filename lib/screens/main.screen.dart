import 'package:fintracker/screens/accounts/accounts.screen.dart';
import 'package:fintracker/screens/categories/categories.screen.dart';
import 'package:fintracker/screens/home/home.screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  final PageController _controller = PageController(keepPage: true);
  int _selected = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          AccountsScreen(),
          CategoriesScreen()
        ],
        onPageChanged: (int index){
          setState(() {
            _selected = index;
          });
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.wallet), label: "Accounts"),
          NavigationDestination(icon: Icon(Icons.category), label: "Categories"),
        ],
        onDestinationSelected: (int selected){
          _controller.jumpToPage(selected);
        },
      ),
      drawer: NavigationDrawer(
        selectedIndex: _selected,
        children: const [
          NavigationDrawerDestination(icon: Icon(Icons.home), label: Text("Home")),
          NavigationDrawerDestination(icon: Icon(Icons.wallet), label: Text("Accounts")),
          NavigationDrawerDestination(icon: Icon(Icons.category), label: Text("Categories")),
          NavigationDrawerDestination(icon: Icon(Icons.settings), label: Text("Settings")),
        ],
        onDestinationSelected: (int selected){
          if(selected < 3){
            _controller.jumpToPage(selected);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}