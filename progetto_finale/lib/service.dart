import 'api_service.dart';
import 'helper.dart';
import 'model.dart';

class Service {

  final ApiService _api = ApiService();

  Future<int> init() async {
    int status = await _api.init();
    await DatabaseHelper.init();
    if (status != 0) {
      try {
        await syncAll();
      } catch (e) {
        return 0;
      }
    }
    return status;
  }

  Future<void> syncAll() async {
    List<Veicolo> veicoli = await _api.getAllVeicoli();
    for (var veicolo in veicoli) {
      await DatabaseHelper.insertVeicolo(veicolo);
    }
    List<Marca> marche = await _api.getAllMarche();
    for (var marca in marche) {
      await DatabaseHelper.insertMarca(marca);
    }
  }

  Future<List<Veicolo>> getVeicoli() async {
    try {
      List<Veicolo> veicoli = await _api.getAllVeicoli();
      for (var veicolo in veicoli) {
        await DatabaseHelper.insertVeicolo(veicolo);
      }
      return veicoli;
    } catch (e) {
      return await DatabaseHelper.getVeicoli();
    }
  }

  Future<List<Marca>> getMarche() async {
    try {
      List<Marca> marche = await _api.getAllMarche();
      for (var marca in marche) {
        await DatabaseHelper.insertMarca(marca);
      }
      return marche;
    } catch (e) {
      return await DatabaseHelper.getMarche();
    }
  }

  Future<void> addVeicolo(Veicolo veicolo) async {
    try {
      await _api.addVeicolo(veicolo);
    } catch (e) {
      // server non raggiungibile
    } finally {
      await DatabaseHelper.insertVeicolo(veicolo);
    }
  }

  Future<void> updateVeicolo(Veicolo veicolo) async {
    try {
      await _api.updateVeicolo(veicolo);
    } catch (e) {
      // server non raggiungibile
    } finally {
      await DatabaseHelper.updateVeicolo(veicolo);
    }
  }

  Future<void> deleteVeicolo(Veicolo veicolo) async {
    try {
      await _api.deleteVeicolo(veicolo.id);
    } catch (e) {
      // server non raggiungibile
    } finally {
      await DatabaseHelper.deleteVeicolo(veicolo);
    }
  }

  Future<void> addMarca(Marca marca) async {
    try {
      await _api.addMarca(marca);
    } catch (e) {
      // server non raggiungibile
    } finally {
      await DatabaseHelper.insertMarca(marca);
    }
  }

  Future<void> deleteMarca(Marca marca) async {
    try {
      await _api.deleteMarca(marca.id.toString());
    } catch (e) {
      // server non raggiungibile
    } finally {
      await DatabaseHelper.deleteMarca(marca);
    }
  }
}