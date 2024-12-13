import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/admin_page.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/desafios_page.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/detail_jogador_ranking_page.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/ranking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home_outlined,
              color: colorScheme.onPrimary,
            ),
            icon: const Icon(Icons.home_outlined),
            label: 'Ranking',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Icons.sports_tennis, color: colorScheme.onPrimary),
            icon: const Icon(Icons.sports_tennis),
            label: 'Desafios',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Icons.person_outline, color: colorScheme.onPrimary),
            icon: const Icon(Icons.person_outline),
            label: 'Perfil',
          ),
          if (Modular.get<AuthController>().usuario?.isAdmin == true)
            NavigationDestination(
              selectedIcon: Icon(
                Icons.admin_panel_settings_outlined,
                color: colorScheme.onPrimary,
              ),
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: 'Admin',
            ),
        ],
      ),
      body: <Widget>[
        /// Ranking page
        const RankingPage(),

        /// Desafios page
        const DesafiosPage(),

        /// Profile page
        DetailJogadorRankingPage(
          usuario: Modular.get<AuthController>().usuario!,
        ),

        /// Admin page
        if (Modular.get<AuthController>().usuario?.isAdmin == true)
          const AdminPage(),
      ][currentPageIndex],
    );
  }
}
