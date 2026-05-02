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