import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notifier.dart';
import 'model.dart';

// home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filtroAlimentazione = 'Tutti';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Veicolo> _filtraVeicoli(List<Veicolo> veicoli) {
    List<Veicolo> risultato = [];
    for (var v in veicoli) {
      bool matchRicerca = _searchQuery.isEmpty ||
          v.marca.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.modello.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchFiltro = _filtroAlimentazione == 'Tutti' ||
          v.alimentazione == _filtroAlimentazione;
      if (matchRicerca && matchFiltro) risultato.add(v);
    }
    return risultato;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<VeicoloNotifier>();
    final veicoli = _filtraVeicoli(notifier.veicoli);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cerca marca o modello...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: ['Tutti', 'Benzina', 'Diesel'].map((filtro) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(filtro),
                  selected: _filtroAlimentazione == filtro,
                  onSelected: (_) =>
                      setState(() => _filtroAlimentazione = filtro),
                  selectedColor: const Color(0xFF1b5e20),
                  labelStyle: TextStyle(
                    color: _filtroAlimentazione == filtro
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: veicoli.isEmpty
              ? const Center(child: Text('Nessun veicolo trovato'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: veicoli.length,
                  itemBuilder: (context, index) =>
                      VeicoloCard(veicolo: veicoli[index]),
                ),
        ),
      ],
    );
  }
}

// card veicolo
class VeicoloCard extends StatelessWidget {
  const VeicoloCard({super.key, required this.veicolo});

  final Veicolo veicolo;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<VeicoloNotifier>();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DettaglioScreen(veicolo: veicolo),
          ),
        ),
        onLongPress: () => notifier.deleteVeicolo(veicolo),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: veicolo.fotoUrl.isNotEmpty
                  ? Image.network(
                      veicolo.fotoUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.directions_car,
                            size: 60,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.directions_car,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${veicolo.marca} ${veicolo.modello}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${veicolo.anno} · ${veicolo.alimentazione} · ${veicolo.km} km · ${veicolo.cv} CV',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '€ ${veicolo.prezzo.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1b5e20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// schermata dettaglio
class DettaglioScreen extends StatelessWidget {
  const DettaglioScreen({super.key, required this.veicolo});

  final Veicolo veicolo;

  Future<void> _apriUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${veicolo.marca} ${veicolo.modello}'),
        backgroundColor: const Color(0xFF1b5e20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            veicolo.fotoUrl.isNotEmpty
                ? Image.network(
                    veicolo.fotoUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.directions_car,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : Container(
                    height: 220,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.directions_car,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Anno',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('${veicolo.anno}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Chilometri',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('${veicolo.km} km',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Alimentazione',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text(veicolo.alimentazione,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cambio',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text(veicolo.cambio,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Colore',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text(veicolo.colore,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('CV',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('${veicolo.cv} CV',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Prezzo',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text(
                        '€ ${veicolo.prezzo.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1b5e20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFe65100),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _apriUrl(
                          'https://impresapiu.subito.it/shops/5936-europecar'),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Vai su Subito.it'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1b5e20),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormScreen(veicolo: veicolo),
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifica auto'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// widget riutilizzabile per i campi del form
class CampoTesto extends StatelessWidget {
  const CampoTesto({
    super.key,
    required this.label,
    required this.controller,
    this.numero = false,
  });

  final String label;
  final TextEditingController controller;
  final bool numero;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: numero ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

// form aggiungi e modifica
class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.veicolo});

  final Veicolo? veicolo;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _marca = TextEditingController();
  final _modello = TextEditingController();
  final _anno = TextEditingController();
  final _prezzo = TextEditingController();
  final _km = TextEditingController();
  final _cv = TextEditingController();
  final _alimentazione = TextEditingController();
  final _colore = TextEditingController();
  final _cambio = TextEditingController();
  final _fotoUrl = TextEditingController();
  bool _disponibile = true;

  @override
  void initState() {
    super.initState();
    if (widget.veicolo != null) {
      final v = widget.veicolo!;
      _marca.text = v.marca;
      _modello.text = v.modello;
      _anno.text = v.anno.toString();
      _prezzo.text = v.prezzo.toString();
      _km.text = v.km.toString();
      _cv.text = v.cv.toString();
      _alimentazione.text = v.alimentazione;
      _colore.text = v.colore;
      _cambio.text = v.cambio;
      _fotoUrl.text = v.fotoUrl;
      _disponibile = v.disponibile;
    }
  }

  @override
  void dispose() {
    for (var c in [
      _marca, _modello, _anno, _prezzo, _km,
      _cv, _alimentazione, _colore, _cambio, _fotoUrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _salva() {
  final notifier = context.read<VeicoloNotifier>();
  final veicolo = Veicolo(
    id: widget.veicolo?.id ?? '',
    marca: _marca.text,
    modello: _modello.text,
    anno: int.tryParse(_anno.text) ?? 0,
    prezzo: double.tryParse(_prezzo.text) ?? 0,
    km: int.tryParse(_km.text) ?? 0,
    cv: int.tryParse(_cv.text) ?? 0,
    alimentazione: _alimentazione.text,
    colore: _colore.text,
    cambio: _cambio.text,
    fotoUrl: _fotoUrl.text,
    urlSubito: '',
    disponibile: _disponibile,
  );
  if (widget.veicolo == null) {
    notifier.addVeicolo(veicolo);
  } else {
    notifier.updateVeicolo(veicolo);
  }
  Navigator.pop(context);
}
  @override
  Widget build(BuildContext context) {
    final isModifica = widget.veicolo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isModifica ? 'Modifica auto' : 'Aggiungi auto'),
        backgroundColor: const Color(0xFF1b5e20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: CampoTesto(label: 'Marca', controller: _marca)),
              const SizedBox(width: 10),
              Expanded(child: CampoTesto(label: 'Modello', controller: _modello)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: CampoTesto(label: 'Anno', controller: _anno, numero: true)),
              const SizedBox(width: 10),
              Expanded(child: CampoTesto(label: 'Prezzo €', controller: _prezzo, numero: true)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: CampoTesto(label: 'Km', controller: _km, numero: true)),
              const SizedBox(width: 10),
              Expanded(child: CampoTesto(label: 'CV', controller: _cv, numero: true)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: CampoTesto(label: 'Alimentazione', controller: _alimentazione)),
              const SizedBox(width: 10),
              Expanded(child: CampoTesto(label: 'Colore', controller: _colore)),
            ]),
            const SizedBox(height: 10),
            CampoTesto(label: 'Cambio', controller: _cambio),
            const SizedBox(height: 10),
            CampoTesto(label: 'URL Foto', controller: _fotoUrl),
            const SizedBox(height: 6),
            SwitchListTile(
              title: const Text('Disponibile alla vendita'),
              value: _disponibile,
              activeThumbColor: const Color(0xFF1b5e20),
              onChanged: (val) => setState(() => _disponibile = val),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1b5e20),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _salva,
                child: Text(isModifica ? 'Salva modifiche' : 'Salva'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// schermata contatti
class ContattiScreen extends StatelessWidget {
  const ContattiScreen({super.key});

  Future<void> _apriUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF1b5e20),
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                Text(
                  'Europe Car SNC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Via Orlanda 45/G · Mestre (VE)',
                  style: TextStyle(
                    color: Color(0xFFa5d6a7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Telefono',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 2),
                        Text('+39 041 268 4847',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        Divider(height: 20),
                        Text('WhatsApp',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 2),
                        Text('+39 328 644 7905',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        Divider(height: 20),
                        Text('Email',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 2),
                        Text('info@europecarsnc.it',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        Divider(height: 20),
                        Text('Indirizzo',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 2),
                        Text('Via Orlanda 45/G, Mestre (VE)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1b5e20),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _apriUrl(
                        'https://impresapiu.subito.it/shops/5936-europecar'),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Vai su Subito.it'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}