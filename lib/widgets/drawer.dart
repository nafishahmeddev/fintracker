import 'package:fintracker/global_event.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget{
  final int selected;
  const MainDrawer({super.key, required this.selected});
  @override
  Widget build(BuildContext context) {
     return NavigationDrawer(
      selectedIndex: selected,
      children: const [
        NavigationDrawerDestination(icon: Icon(Icons.home), label: Text("Home")),
        NavigationDrawerDestination(icon: Icon(Icons.wallet), label: Text("Accounts")),
        NavigationDrawerDestination(icon: Icon(Icons.category), label: Text("Categories")),
        NavigationDrawerDestination(icon: Icon(Icons.settings), label: Text("Settings")),
      ],
      onDestinationSelected: (int selected){
        io.emit("main-page-destination-change", selected);
      },
    );
  }

}