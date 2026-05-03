import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class ApiService {

  static const String baseUrl = 'http://192.168.1.2:3000';

  Future<int> init() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/veicoli'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Veicolo>> getAllVeicoli() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/veicoli'));
      if (response.statusCode == 200) {
        List body = jsonDecode(response.body);
        return body.map((json) => Veicolo.fromMap(json)).toList();
      } else {
        throw Exception('Errore nel caricamento veicoli: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addVeicolo(Veicolo veicolo) async {
    final map = veicolo.toMap();
    map.remove('id');
    await http.post(
      Uri.parse('$baseUrl/veicoli'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(map),
    );
  }

  Future<void> updateVeicolo(Veicolo veicolo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/veicoli/${veicolo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(veicolo.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Errore modifica: ${response.statusCode}');
    }
  }

  Future<void> deleteVeicolo(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/veicoli/$id'),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Errore eliminazione: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Marca>> getAllMarche() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/marche'));
      if (response.statusCode == 200) {
        List body = jsonDecode(response.body);
        return body.map((json) => Marca.fromMap(json)).toList();
      } else {
        throw Exception('Errore nel caricamento marche: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMarca(Marca marca) async {
    await http.post(
      Uri.parse('$baseUrl/marche'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(marca.toMap()),
    );
  }

  Future<void> deleteMarca(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/marche/$id'),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Errore eliminazione marca: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}