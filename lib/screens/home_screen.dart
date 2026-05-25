import 'package:flutter/material.dart';
import 'dart:async';
import '../models/alerte.dart';
import '../services/api_service.dart';
import 'historique_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String etat         = 'NORMAL';
  String zone         = 'Zone M1';
  String date         = '--/--/----';
  String heure        = '--:--';
  int    valeur       = 0;
  String tourelles    = 'INCONNU';
  String ouvrants     = 'INCONNU';
  String cta          = 'INCONNU';
  int    niveau       = 0;
  String diagnostic   = 'Aucune alerte';
  double temperature  = 0.0;
  double diffPression = 0.0;
  List<Alerte> dernieresAlertes = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    chargerDerniereAlerte();
    _timer = Timer.periodic(const Duration(seconds: 3), (t) {
      chargerDerniereAlerte();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> chargerDerniereAlerte() async {
    final alertes = await ApiService.getAlertes();
    if (!mounted) return;
    if (alertes.isNotEmpty) {
      final d = alertes.first;
      setState(() {
        etat         = d.message;
        zone         = 'Zone ${d.zone}';
        date         = d.date;
        heure        = d.heure;
        valeur       = d.valeur;
        tourelles    = d.tourelles;
        ouvrants     = d.ouvrants;
        cta          = d.cta;
        niveau       = d.niveau;
        diagnostic   = d.diagnostic;
        temperature  = d.temperature;
        diffPression = d.diffPression;
        dernieresAlertes = alertes.take(3).toList();
      });
    }
  }

  Future<void> acquitter() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Acquitter alarme'),
        content: const Text(
            'Voulez-vous stopper l\'alarme ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await ApiService.acquitter('M1');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? 'Alarme acquittée avec succès'
                        : 'Erreur connexion'),
                    backgroundColor:
                        ok ? Colors.green : Colors.red,
                  ),
                );
                if (ok) chargerDerniereAlerte();
              }
            },
            child: const Text('Confirmer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> commanderEquipement(
      String equipement,
      String commande,
      String messageConfirm) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded,
                color: Colors.orange),
            SizedBox(width: 8),
            Text('Confirmation'),
          ],
        ),
        content: Text(messageConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange),
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await ApiService.commanderEquipement(
                  equipement, commande);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? 'Commande envoyée avec succès'
                        : 'Erreur connexion'),
                    backgroundColor:
                        ok ? Colors.green : Colors.red,
                  ),
                );
                if (ok) {
                  await Future.delayed(
                      const Duration(milliseconds: 1500));
                  chargerDerniereAlerte();
                }
              }
            },
            child: const Text('Confirmer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  bool get enIncendie => etat.contains('INCENDIE');

  Color get couleurEtat {
    if (!enIncendie) return Colors.green;
    if (niveau == 2) return Colors.red;
    if (niveau == 1) return Colors.orange;
    return Colors.red;
  }

  Color couleurEquipement(String e) {
    if (e == 'ACTIF')     return Colors.green;
    if (e == 'INACTIF')   return Colors.grey;
    if (e == 'ARRETEE')   return Colors.green;
    if (e == 'EN MARCHE') return Colors.red;
    return Colors.grey;
  }

  IconData iconeEquipement(String e) {
    if (e == 'ACTIF')     return Icons.check_circle;
    if (e == 'INACTIF')   return Icons.cancel;
    if (e == 'ARRETEE')   return Icons.check_circle;
    if (e == 'EN MARCHE') return Icons.cancel;
    return Icons.help_outline;
  }

  Widget ligneEquipement(String nom, String etatEquip) {
    final couleur = couleurEquipement(etatEquip);
    final icone   = iconeEquipement(etatEquip);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, color: couleur, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(nom,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: couleur.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: couleur, width: 0.8),
            ),
            child: Text(
              etatEquip,
              style: TextStyle(
                  color: couleur,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget carteCapteurs() {
    Color couleurPression;
    String etatPression;
    IconData iconePression;
    if (diffPression > 0) {
      couleurPression = Colors.green;
      etatPression    = 'NORMAL';
      iconePression   = Icons.check_circle_outline;
    } else if (diffPression > -20) {
      couleurPression = Colors.orange;
      etatPression    = 'ALERTE';
      iconePression   = Icons.warning_amber_rounded;
    } else {
      couleurPression = Colors.red;
      etatPression    = 'CRITIQUE';
      iconePression   = Icons.cancel_outlined;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Capteurs environnement',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.thermostat,
                  color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                  child: Text('Température',
                      style: TextStyle(fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.orange, width: 0.8),
                ),
                child: Text(
                  '${temperature.toStringAsFixed(1)} °C',
                  style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(iconePression,
                  color: couleurPression, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                  child: Text('Pression différentielle',
                      style: TextStyle(fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: couleurPression.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: couleurPression, width: 0.8),
                ),
                child: Text(
                  '$etatPression  ${diffPression.toStringAsFixed(1)} Pa',
                  style: TextStyle(
                      color: couleurPression,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget boutonControle({
    required String label,
    required String texteBtn,
    required Color couleurBtn,
    required VoidCallback onPressed,
    required IconData icone,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleurBtn,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icone, color: Colors.white, size: 20),
          label: Text(
            '$label — $texteBtn',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget carteControle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('Contrôle des équipements',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text('(intervention manuelle)',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Divider(height: 20),

          boutonControle(
            label: 'Tourelle extraction',
            texteBtn:
                tourelles == 'ACTIF' ? 'Fermer' : 'Démarrer',
            couleurBtn: tourelles == 'ACTIF'
                ? Colors.red[600]!
                : Colors.green[600]!,
            icone: tourelles == 'ACTIF'
                ? Icons.stop_circle_outlined
                : Icons.play_circle_outline,
            onPressed: () {
              if (tourelles == 'ACTIF') {
                commanderEquipement('tourelle', 'stop',
                    'Voulez-vous arrêter la tourelle ?');
              } else {
                commanderEquipement('tourelle', 'start',
                    'Voulez-vous démarrer la tourelle ?');
              }
            },
          ),

          boutonControle(
            label: 'Ouvrant air neuf',
            texteBtn:
                ouvrants == 'ACTIF' ? 'Fermer' : 'Ouvrir',
            couleurBtn: ouvrants == 'ACTIF'
                ? Colors.orange[700]!
                : Colors.green[600]!,
            icone: ouvrants == 'ACTIF'
                ? Icons.door_back_door_outlined
                : Icons.door_sliding_outlined,
            onPressed: () {
              if (ouvrants == 'ACTIF') {
                commanderEquipement('ouvrant', 'fermer',
                    'Voulez-vous fermer l\'ouvrant ?');
              } else {
                commanderEquipement('ouvrant', 'ouvrir',
                    'Voulez-vous ouvrir l\'ouvrant ?');
              }
            },
          ),

          boutonControle(
            label: 'CTA',
            texteBtn:
                cta == 'ARRETEE' ? 'Allumer' : 'Arrêter',
            couleurBtn: cta == 'ARRETEE'
                ? const Color(0xFF1B5E20)
                : Colors.red[600]!,
            icone: cta == 'ARRETEE'
                ? Icons.power
                : Icons.power_off_outlined,
            onPressed: () {
              if (cta == 'ARRETEE') {
                commanderEquipement('cta', 'demarrer',
                    'Voulez-vous allumer la CTA ?');
              } else {
                commanderEquipement('cta', 'arreter',
                    'Voulez-vous arrêter la CTA ?');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Carte état principal ──────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: couleurEtat,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  enIncendie
                      ? Icons.local_fire_department
                      : Icons.check_circle,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  enIncendie ? etat : 'Zone M1 OK',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(zone,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(date,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(heure,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13)),
                  ],
                ),
                if (enIncendie) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white54, width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('DANGER — INCENDIE EN COURS',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Bannière incendie ─────────────────────
          if (enIncendie)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  left: BorderSide(
                      color: Colors.red[700]!, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Incendie détecté — Système activé automatiquement',
                    style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Intervenir manuellement via les boutons ci-dessous',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

          // ── Carte capteurs ────────────────────────
          carteCapteurs(),
          const SizedBox(height: 12),

          // ── Carte état équipements ────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('État des équipements',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const Divider(height: 20),
                ligneEquipement(
                    'Tourelle d\'extraction', tourelles),
                ligneEquipement('Ouvrant air neuf', ouvrants),
                ligneEquipement('CTA', cta),
              ],
            ),
          ),

          const SizedBox(height: 12),
          carteControle(),
          const SizedBox(height: 12),

          // ── Bouton acquittement ───────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: acquitter,
              icon: const Icon(Icons.alarm_off,
                  color: Colors.grey),
              label: const Text('Acquitter alarme',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 20),

          // ── Dernières alertes ─────────────────────
          const Text('Dernières alertes',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          dernieresAlertes.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Aucune alerte récente',
                        style:
                            TextStyle(color: Colors.grey)),
                  ),
                )
              : Column(
                  children: dernieresAlertes
                      .map((a) => Card(
                            margin: const EdgeInsets.only(
                                bottom: 8),
                            child: ListTile(
                              leading: const Icon(
                                  Icons
                                      .local_fire_department,
                                  color: Colors.red),
                              title: Text(a.message,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 13)),
                              subtitle: Text(
                                  '${a.date}  ${a.heure}  —  Zone ${a.zone}',
                                  style: const TextStyle(
                                      fontSize: 12)),
                              trailing: Text('${a.valeur}',
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight:
                                          FontWeight.bold)),
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}