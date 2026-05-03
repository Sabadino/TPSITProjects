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
- `marca` marca del veicolo (es. Audi, Volkswagen)
- `modello` modello specifico (es. RS6 Avant)
- `anno` anno di immatricolazione
- `prezzo` prezzo di vendita in euro
- `km` chilometri percorsi
- `alimentazione` tipo di carburante (Benzina, Diesel)
- `colore` colore della carrozzeria
- `cambio` tipo di cambio (Manuale, Automatico)
- `cv` potenza del motore in cavalli
- `disponibile` INTEGER 0 o 1, SQLite non supporta i boolean
- `fotoUrl` URL dell'immagine del veicolo

### Tabella `marche` (json-server e SQLite)
- `id` identificativo univoco della marca
- `nome` nome della marca (es. Audi, Mercedes)
- `nazione` paese di origine della marca

## Scelte progettuali

**json-server**
Permette di simulare un backend REST completo senza scrivere una riga
di codice server. Con un unico file db.json espone automaticamente
tutti gli endpoint: GET, POST, PUT, PATCH e DELETE. Ho scelto
json-server perché è semplice da avviare e mi ha permesso di
concentrarmi sulla parte Flutter senza dovermi preoccupare del backend.

**sqflite per la cache**
Leggero, ben documentato e usa query SQL familiari. Scelto rispetto a
ObjectBox per la semplicità. La cache salva i dati ogni volta che
vengono scaricati dal server, così se si perde la connessione il
catalogo resta consultabile lo stesso.

**Provider con ChangeNotifier**
Scelto per gestire lo stato dell'app in modo pulito. Ogni volta che i
dati cambiano, notifyListeners() aggiorna automaticamente tutti i
widget che lo ascoltano, senza dover chiamare setState in ogni
schermata. È lo stesso pattern usato a lezione che ho adattato al
mio progetto.

**Service come strato intermedio**
Ho separato la logica in una classe Service che decide da dove
prendere i dati, server o cache. Se il server risponde scarica
tutto e aggiorna SQLite, altrimenti legge da SQLite. In questo modo
ogni parte del codice ha un compito preciso e non si mischiano
responsabilità diverse.

**toMap() e fromMap()**
Ogni classe ha questi due metodi. toMap() converte l'oggetto in una
mappa per salvarlo in SQLite o inviarlo al server. fromMap() fa il
contrario e ricostruisce l'oggetto dai dati ricevuti. Stesso pattern
del codice visto a lezione, l'ho trovato molto comodo da usare.

**ConflictAlgorithm.replace**
Usato nell'inserimento in SQLite. Se trova due record con lo stesso
id aggiorna quello vecchio con i nuovi dati. È fondamentale quando
si sincronizzano i dati dal server alla cache, altrimenti si
otterrebbero duplicati.

**CampoTesto widget riutilizzabile**
Nel form ho creato un widget separato CampoTesto invece di ripetere
la stessa struttura TextField per ogni campo. Se devo cambiare lo
stile lo cambio in un posto solo. L'ho fatto dopo aver letto la
documentazione Flutter sui widget riutilizzabili, ha senso non
ripetersi.

**Long press per eliminare**
Ho scelto il long press sulla card per eliminare un veicolo, stesso
approccio usato nel codice visto a lezione. Mantiene l'interfaccia
pulita senza aggiungere pulsanti extra che avrebbero appesantito
la grafica.

**Logica offline**
Se il server non risponde, Service legge dalla cache SQLite. La
variabile isOffline in VeicoloNotifier tiene traccia dello stato
della connessione e la UI lo mostra con un'icona arancione nell'appbar.
Ho scelto di non bloccare le operazioni di lettura offline, il
catalogo resta sempre consultabile.


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

