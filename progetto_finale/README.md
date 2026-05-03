# Il Mondo dell'Auto
**Sviluppatore:** Hadi Hammoud  
**Classe:** 5IE

## Motivazione
Il Mondo dell'Auto nasce da un'esigenza concreta. Mio padre ha un
concessionario, Europe Car SNC a Mestre, e gestisce il catalogo ancora
in modo tradizionale, quindi ho scelto di fare questa app come progetto
finale per aiutare mio padre.

## Descrizione
Il cliente può sfogliare le auto in vendita, vedere i 
dettagli e contattare il concessionario direttamente da app. 
Chi gestisce il catalogo può aggiungere, modificare ed eliminare veicoli.
Ho usato SQLite come cache locale, così se non c'è connessione le auto 
già caricate restano visibili.

## Specifiche tecniche

### Tecnologie utilizzate
- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Local Database:** sqflite
- **Networking:** http
- **Remote Database:** json-server
- **Navigazione esterna:** url_launcher

### Architettura del progetto
- `model.dart` definisce le entità Veicolo e Marca con metodi toMap() e fromMap()
- `helper.dart` gestisce il database locale tramite sqflite
- `api_service.dart` gestisce la comunicazione con il server json-server
- `service.dart` fa da ponte tra server locale e server remoto
- `notifier.dart` gestisce lo stato globale tramite Provider e ChangeNotifier
- `widget.dart` contiene tutte le schermate e i widget dell'app

## Struttura del database

### Tabella `veicoli` (json-server e SQLite)
- `id` identificativo univoco del veicolo
- `marca` marca del veicolo (es. Audi)
- `modello` modello specifico (es. RS6 Avant)
- `anno` anno di immatricolazione
- `prezzo` prezzo di vendita in euro
- `km` chilometri percorsi
- `alimentazione` tipo di carburante (Benzina, Diesel)
- `colore` colore della carrozzeria
- `cambio` tipo di cambio (Manuale, Automatico)
- `cv` potenza del motore in cavalli
- `fotoUrl` URL dell'immagine del veicolo

### Tabella `marche` (json-server e SQLite)
- `id` identificativo univoco della marca
- `nome` nome della marca (es. Audi, Mercedes)
- `nazione` paese di origine della marca

## Scelte progettuali


**json-server**
Ho scelto json-server perché con un solo file db.json espone
automaticamente tutti gli endpoint: GET, POST, PUT, PATCH e DELETE.
Non dover scrivere codice backend mi ha permesso di concentrarmi
interamente sulla parte Flutter.

**sqflite per la cache**
Usa query SQL che già conosco ed è ben documentato. Ho scartato
ObjectBox perché aggiungeva complessità inutile. Ogni volta che
scarico i dati dal server li salvo anche in locale, così se si
perde la connessione l'app funziona lo stesso.

**Provider con ChangeNotifier**
Scelto per gestire lo stato dell'app in modo pulito. Ogni volta che i
dati cambiano, notifyListeners() aggiorna automaticamente tutti i
widget che lo ascoltano, senza dover chiamare setState in ogni
schermata. È lo stesso pattern usato a lezione che ho adattato al
mio progetto

**Service come strato intermedio**
Ho creato una classe Service in mezzo tra API e SQLite per non
mischiare tutto insieme. Decide da dove prendere i dati: se il
server risponde lo usa, altrimenti legge dalla cache. Ogni classe
ha una responsabilità precisa.

**toMap() e fromMap()**
Convertono gli oggetti Dart in mappe e viceversa. Servono sia per
salvare in SQLite che per comunicare col server. Li ho visti nel
codice del prof e li ho adattati alle mie classi.

**ConflictAlgorithm.replace**
Quando inserisco un record in SQLite con un id già esistente lo
sovrascrive invece di dare errore. Utile quando sincronizzo dal
server perché voglio sempre avere la versione più aggiornata.

**CampoTesto widget riutilizzabile**
Nel form avevo undici campi TextField quasi identici. Ho creato
un widget CampoTesto che prende label e controller come parametri
così non ripeto lo stesso codice undici volte.

**Long press per eliminare**
Preso dal codice del prof. Tenere premuto sulla card elimina il
veicolo senza aggiungere pulsanti extra nell'interfaccia.

**Logica offline**
Quando il server non risponde, Service legge dalla cache SQLite.
La variabile isOffline in VeicoloNotifier tiene traccia della
connessione e l'appbar mostra un'icona arancione. Il catalogo
resta sempre consultabile anche senza connessione.

Il pulsante Subito.it richiede una configurazione aggiuntiva nel 
file AndroidManifest.xml per abilitare il traffico HTTP e i 
permessi per aprire URL esterni.

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
Ho creato widget.dart con tutte le schermate dell'app: HomeScreen
con ricerca e filtri, VeicoloCard per ogni auto in lista,
DettaglioScreen con i dati tecnici e il pulsante Subito.it,
FormScreen per aggiungere e modificare auto, e ContattiScreen con
i contatti del concessionario.


## Considerazioni finali
Questo progetto è stato più interessante del previsto proprio perché
non era un esercizio astratto, c'era un'esigenza reale dietro.
Se potessi migliorare il progetto in futuro aggiungerei un backend
reale con PHP e MySQL, l'upload delle foto direttamente dall'app,
e magari le notifiche push quando arriva una nuova auto in catalogo.
Spero sinceramente che mio padre inizierà ad usare l'app per
gestire il suo concessionario.

Forza Inter. ⚫🔵

