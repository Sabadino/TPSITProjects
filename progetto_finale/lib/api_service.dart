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
    await http.post(
      Uri.parse('$baseUrl/veicoli'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(veicolo.toMap()),
    );
  }

  Future<void> updateVeicolo(Veicolo veicolo) async {
    await http.put(
      Uri.parse('$baseUrl/veicoli/${veicolo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(veicolo.toMap()),
    );
  }

  Future<void> patchVeicolo(int id, Map<String, dynamic> data) async {
    await http.patch(
      Uri.parse('$baseUrl/veicoli/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<void> deleteVeicolo(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/veicoli/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Errore durante l\'eliminazione del veicolo');
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

  Future<void> deleteMarca(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/marche/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Errore durante l\'eliminazione della marca');
      }
    } catch (e) {
      rethrow;
    }
  }
}