import 'package:flutter/material.dart';
import 'model.dart';
import 'service.dart';

class VeicoloNotifier with ChangeNotifier {

  final veicoli = <Veicolo>[];
  final marche = <Marca>[];

  bool _isInitialized = false;
  bool isOffline = false;

  final Service _service = Service();

  Future<void> init() async {
    if (_isInitialized) return;
    int result = await _service.init();
    isOffline = (result == 0);
    await refreshData();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> refreshData() async {
    veicoli.clear();
    marche.clear();
    final localVeicoli = await _service.getVeicoli();
    final localMarche = await _service.getMarche();
    veicoli.addAll(localVeicoli);
    marche.addAll(localMarche);
    notifyListeners();
  }

  Future<void> addVeicolo(Veicolo veicolo) async {
    await _service.addVeicolo(veicolo);
    await refreshData();
  }

  Future<void> updateVeicolo(Veicolo veicolo) async {
    await _service.updateVeicolo(veicolo);
    await refreshData();
  }

  Future<void> deleteVeicolo(Veicolo veicolo) async {
    await _service.deleteVeicolo(veicolo);
    await refreshData();
  }

  Future<void> addMarca(Marca marca) async {
    await _service.addMarca(marca);
    await refreshData();
  }

  Future<void> deleteMarca(Marca marca) async {
    await _service.deleteMarca(marca);
    await refreshData();
  }
}