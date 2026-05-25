import 'package:flutter/material.dart';
import '../models/alerte.dart';
import '../services/api_service.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});
  @override
  State<HistoriqueScreen> createState() =>
      _HistoriqueScreenState();
}

class _HistoriqueScreenState
    extends State<HistoriqueScreen> {
  List<Alerte> alertes = [];
  bool loading = false;

  @override
  void initState() {
    
    super.initState();
    chargerAlertes();
  }

  Future<void> chargerAlertes() async {
    setState(() { loading = true; });
    final data = await ApiService.getAlertes();
    setState(() {
      alertes = data;
      loading = false;
    });
  }

  Color couleurNiveau(int niveau) {
    if (niveau == 2) return Colors.red;
    if (niveau == 1) return Colors.orange;
    return Colors.green;
  }

  String texteNiveau(int niveau) {
    if (niveau == 2) return 'CRITIQUE';
    if (niveau == 1) return 'ALERTE';
    return 'NORMAL';
  }

  Color couleurEquipement(String e) {
    if (e == 'ACTIF')     return Colors.green;
    if (e == 'INACTIF')   return Colors.red;
    if (e == 'ARRETEE')   return Colors.green;
    if (e == 'EN MARCHE') return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Historique des alertes',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[700],
        iconTheme:
            const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,
                color: Colors.white),
            onPressed: chargerAlertes,
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Colors.red))
          : alertes.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune alerte enregistrée',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: alertes.length,
                  itemBuilder: (context, index) {
                    final a = alertes[index];
                    final couleur =
                        couleurNiveau(a.niveau);
                    return Card(
                      margin: const EdgeInsets.only(
                          bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                        side: BorderSide(
                            color: couleur
                                .withOpacity(0.3)),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // Entête
                            Row(
                              children: [
                                Icon(
                                    Icons
                                        .local_fire_department,
                                    color: couleur,
                                    size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    a.message,
                                    style: TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        fontSize: 14,
                                        color: couleur),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                          horizontal: 8,
                                          vertical: 3),
                                  decoration:
                                      BoxDecoration(
                                    color: couleur
                                        .withOpacity(
                                            0.1),
                                    borderRadius:
                                        BorderRadius
                                            .circular(8),
                                    border: Border.all(
                                        color: couleur),
                                  ),
                                  child: Text(
                                    texteNiveau(
                                        a.niveau),
                                    style: TextStyle(
                                        color: couleur,
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight
                                                .bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Date heure zone
                            Row(
                              children: [
                                const Icon(
                                    Icons.calendar_today,
                                    size: 13,
                                    color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                    '${a.date}  ${a.heure}  —  Zone ${a.zone}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            Colors.grey)),
                              ],
                            ),
                            const Divider(height: 16),
                            // État équipements
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                _badge('Tourelle',
                                    a.tourelles),
                                _badge('Clapet',
                                    a.clapets),
                                _badge('Ouvrant',
                                    a.ouvrants),
                                _badge('CTA', a.cta),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _badge(String label, String etat) {
    Color couleur;
    if (etat == 'ACTIF' || etat == 'ARRETEE') {
      couleur = Colors.green;
    } else if (etat == 'INACTIF' ||
        etat == 'EN MARCHE') {
      couleur = Colors.red;
    } else {
      couleur = Colors.grey;
    }
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: couleur.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border:
                Border.all(color: couleur, width: 0.5),
          ),
          child: Text(
            etat,
            style: TextStyle(
                color: couleur,
                fontSize: 10,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}