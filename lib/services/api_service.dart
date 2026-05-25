import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/alerte.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.146:1880/api';

  // Récupérer toutes les alertes
  static Future<List<Alerte>> getAlertes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alertes'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((j) => Alerte.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      print('Erreur API: $e');
      return [];
    }
  }

  // Acquitter une alarme
  static Future<bool> acquitter(String zone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/acquitter'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'zone': zone}),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur acquittement: $e');
      return false;
    }
  }

  // Commander un équipement
  static Future<bool> commanderEquipement(
      String equipement, String commande) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/commande/$equipement'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'commande': commande}),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur commande: $e');
      return false;
    }
  }
}