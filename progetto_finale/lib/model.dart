

class Veicolo {
  Veicolo({
    required this.id,
    required this.marca,
    required this.modello,
    required this.anno,
    required this.prezzo,
    required this.km,
    required this.alimentazione,
    required this.colore,
    required this.cambio,
    required this.cv,
    required this.disponibile,
    this.fotoUrl = '',
    this.urlSubito = '',
  });

  final int id;
  String marca;
  String modello;
  int anno;
  double prezzo;
  int km;
  String alimentazione;
  String colore;
  String cambio;
  int cv;
  bool disponibile;
  String fotoUrl;
  String urlSubito;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marca': marca,
      'modello': modello,
      'anno': anno,
      'prezzo': prezzo,
      'km': km,
      'alimentazione': alimentazione,
      'colore': colore,
      'cambio': cambio,
      'cv': cv,
      // bool -> INTEGER (SQLite non supporta bool)
      'disponibile': disponibile ? 1 : 0,
      'fotoUrl': fotoUrl,
      'urlSubito': urlSubito,
    };
  }

  factory Veicolo.fromMap(Map<String, dynamic> map) {
    return Veicolo(
      id: int.tryParse(map['id'].toString()) ?? 0,
      marca: map['marca'],
      modello: map['modello'],
      anno: int.tryParse(map['anno'].toString()) ?? 0,
      prezzo: double.tryParse(map['prezzo'].toString()) ?? 0,
      km: int.tryParse(map['km'].toString()) ?? 0,
      alimentazione: map['alimentazione'],
      colore: map['colore'],
      cambio: map['cambio'],
      cv: int.tryParse(map['cv'].toString()) ?? 0,
      disponibile: map['disponibile'] == 1 || map['disponibile'] == true,
      fotoUrl: map['fotoUrl'] ?? '',
      urlSubito: map['urlSubito'] ?? '',
    );
  }
}

class Marca {
  Marca({
    required this.id,
    required this.nome,
    required this.nazione,
  });

  final int id;
  String nome;
  String nazione;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'nazione': nazione,
    };
  }

  factory Marca.fromMap(Map<String, dynamic> map) {
    return Marca(
      id: int.tryParse(map['id'].toString()) ?? 0,
      nome: map['nome'],
      nazione: map['nazione'],
    );
  }
}