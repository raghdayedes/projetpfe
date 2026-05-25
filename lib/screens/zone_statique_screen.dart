import 'package:flutter/material.dart';

class ZoneStatiqueScreen extends StatelessWidget {
  final String zone;
  const ZoneStatiqueScreen({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // ── Carte état principal ──────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle,
                    color: Colors.white, size: 50),
                const SizedBox(height: 8),
                Text(
                  'Zone $zone — Normal',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Zone $zone',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.white70, size: 14),
                    SizedBox(width: 4),
                    Text('--/--/----',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    SizedBox(width: 16),
                    Icon(Icons.access_time,
                        color: Colors.white70, size: 14),
                    SizedBox(width: 4),
                    Text('--:--',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Carte capteurs ────────────────────────
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
                const Text('Capteurs environnement',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const Divider(height: 20),
                _ligneCapteur(
                  icone: Icons.thermostat,
                  couleur: Colors.orange,
                  label: 'Température',
                  valeur: '24.5 °C',
                  etat: '',
                  couleurEtat: Colors.orange,
                ),
                const SizedBox(height: 10),
                _ligneCapteur(
                  icone: Icons.compress,
                  couleur: Colors.green,
                  label: 'Pression différentielle',
                  valeur: '',
                  etat: 'NORMAL  0.03 Pa',
                  couleurEtat: Colors.green,
                ),
              ],
            ),
          ),

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
                _ligneEquipement('Tourelle d\'extraction', 'INACTIF'),
                _ligneEquipement('Ouvrant air neuf', 'INACTIF'),
                _ligneEquipement('CTA', 'EN MARCHE'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Carte contrôle ────────────────────────
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
                _boutonControle(
                    'Tourelle extraction — Démarrer',
                    Colors.green[600]!,
                    Icons.play_circle_outline),
                const SizedBox(height: 10),
                _boutonControle(
                    'Ouvrant air neuf — Ouvrir',
                    Colors.green[600]!,
                    Icons.door_sliding_outlined),
                const SizedBox(height: 10),
                _boutonControle(
                    'CTA — Arrêter',
                    Colors.red[600]!,
                    Icons.power_off_outlined),
              ],
            ),
          ),

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
              onPressed: null,
              icon: const Icon(Icons.alarm_off, color: Colors.grey),
              label: const Text('Acquitter alarme',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 20),

          // ── Dernières alertes ─────────────────────
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Dernières alertes',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Aucune alerte récente pour la Zone $zone',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ligneCapteur({
    required IconData icone,
    required Color couleur,
    required String label,
    required String valeur,
    required String etat,
    required Color couleurEtat,
  }) {
    return Row(
      children: [
        Icon(icone, color: couleur, size: 20),
        const SizedBox(width: 8),
        Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 14))),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: couleurEtat.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: couleurEtat, width: 0.8),
          ),
          child: Text(
            valeur.isNotEmpty ? valeur : etat,
            style: TextStyle(
                color: couleurEtat,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _ligneEquipement(String nom, String etatEquip) {
    Color couleur;
    IconData icone;
    if (etatEquip == 'ACTIF') {
      couleur = Colors.green;
      icone   = Icons.check_circle;
    } else if (etatEquip == 'EN MARCHE') {
      couleur = Colors.red;
      icone   = Icons.cancel;
    } else {
      couleur = Colors.grey;
      icone   = Icons.help_outline;
    }
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
                      fontWeight: FontWeight.w500))),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: couleur.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: couleur, width: 0.8),
            ),
            child: Text(etatEquip,
                style: TextStyle(
                    color: couleur,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _boutonControle(
      String label, Color couleur, IconData icone) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: couleur,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: null, // désactivé — zone statique
        icon: Icon(icone, color: Colors.white, size: 20),
        label: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}