import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'zone_statique_screen.dart';
import 'historique_screen.dart';
import 'login_screen.dart';

final GlobalKey<HomeScreenState> homeScreenKey =
    GlobalKey<HomeScreenState>();

class ZonesScreen extends StatefulWidget {
  const ZonesScreen({super.key});

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends State<ZonesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Système Désenfumage',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[700],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Zone M1'),
            Tab(text: 'Zone M2'),
            Tab(text: 'Emballage'),
          ],
        ),
        actions: [
          // ── Refresh ────────────────────────────
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Rafraîchir',
            onPressed: () {
              if (_tabController.index == 0) {
                homeScreenKey.currentState
                    ?.chargerDerniereAlerte();
              }
            },
          ),
          // ── Historique ─────────────────────────
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Historique',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const HistoriqueScreen()),
            ),
          ),
          // ── Déconnexion ────────────────────────
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Déconnexion',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text(
                      'Voulez-vous vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Déconnecter',
                          style: TextStyle(
                              color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreen(key: homeScreenKey),
          const ZoneStatiqueScreen(zone: 'M2'),
          const ZoneStatiqueScreen(zone: 'Emballage'),
        ],
      ),
    );
  }
}