# Il Mondo dell'Auto
**Sviluppatore:** Hadi Hammoud  
**Classe:** 5IE

## Descrizione
L'idea è creare un'app per il concessionario di famiglia Europe Car SNC 
di Mestre (VE). Il cliente può sfogliare le auto in vendita, vedere i 
dettagli e contattare il concessionario direttamente da app. 
Chi gestisce il catalogo può aggiungere, modificare ed eliminare veicoli.
Ho usato SQLite come cache locale, così se non c'è connessione le auto 
già caricate restano visibili.

## Diario di progetto

### Step 1 — init
Ho creato il progetto Flutter e configurato json-server con
il file db.json contenente le tabelle veicoli e marche con
5 auto reali del concessionario. Ho anche impostato il README
con la struttura del progetto.

### Step 2 — models
Ho creato model.dart con le classi Veicolo e Marca. Ogni classe
ha toMap() e fromMap() per convertire i dati da e verso SQLite
e il server. Il campo disponibile lo salvo come INTEGER perché
SQLite non supporta i booleani.

### Step 3 — helper
Ho creato helper.dart con la classe DatabaseHelper per gestire
il database SQLite locale. Uso il singleton per non riaprire
il database ogni volta, e ConflictAlgorithm.replace per
sovrascrivere i dati vecchi quando arrivano quelli nuovi dal server.
Ho creato due tabelle: veicoli e marche.

### Step 4 — api_service e service
Ho creato api_service.dart per gestire le chiamate HTTP al server
con GET, POST, PUT, PATCH e DELETE. Ho aggiunto service.dart come
strato intermedio che decide se prendere i dati dal server o dalla
cache SQLite quando si è offline.


### Step 5 — notifier
Ho creato notifier.dart con VeicoloNotifier che gestisce lo stato
dell'app usando Provider e ChangeNotifier. Ogni volta che i dati
cambiano chiama notifyListeners() per aggiornare automaticamente
la UI. Tiene traccia anche dello stato offline con la variabile
isOffline.

### Step 6 — main
Ho creato main.dart con MyApp che inizializza Provider e il tema
verde dell'app. La schermata principale ha un bottom nav con Home
e Contatti, il floating action button per aggiungere auto e un'icona che avvisa
quando si è offline.

### Step 7 — widgets
Ho creato widgets.dart con tutte le schermate dell'app: HomeScreen
con ricerca e filtri, VeicoloCard per ogni auto in lista,
DettaglioScreen con i dati tecnici e i pulsanti WhatsApp e Subito,
FormScreen per aggiungere e modificare auto, e ContattiScreen con
i contatti del concessionario e gli orari. Ho completato anche
main.dart con la navigazione tra le schermate e il bottom nav.