import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_flutter/global.dart';
import 'package:ticket_flutter/model/destination.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell,required this.dest, super.key});

  final StatefulNavigationShell navigationShell;
  final List<Destination>dest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      backgroundColor: Colors.transparent,
      drawerScrimColor: Colors.transparent,

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
       indicatorColor: Theme.of(context).primaryColor, // Couleur de l'indicateur
  backgroundColor: Colors.transparent, // Fond transparent
  surfaceTintColor: Colors.transparent, // Assurez-vous que la teinte est désactivée
  shadowColor: Colors.transparent, // Supprimez l'ombre
        
        destinations: dest
            .map((dest) => NavigationDestination(
                  icon: Icon(dest.icon),
                  label: dest.label,
                  selectedIcon: Icon(
                    dest.icon,
                    color: Colors.white,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
