# ZKEEP
Sviluppatore: [Hadi Hammoud]  
Classe: 5IE

## Descrizione
Questo progetto è una versione semplice di Google Keep fatta in Flutter.  
L’idea è avere più note (card) e dentro ogni nota una lista di promemoria (todo) da spuntare.

Ho usato SQLite per salvare i dati in locale, così quando riapro l’app le note restano.

## Cosa fa l’app
- aggiunge una nuova nota con il bottone `+`
- mostra le note in una griglia
- dentro ogni nota puoi:
  - aggiungere un promemoria
  - modificare il testo
  - spuntare / togliere la spunta
  - eliminare un promemoria
  - eliminare tutta la nota

## Struttura file
- `lib/main.dart` → avvio app e schermata principale
- `lib/model.dart` → classi `Todo` e `TodoCard`
- `lib/notifier.dart` → logica dell’app (aggiungi, elimina, update)
- `lib/helper.dart` → gestione database SQLite
- `lib/widgets.dart` → widget grafici delle card e dei todo

## Scelte fatte
Ho cercato di tenerlo lineare e leggibile, senza roba complicata:
- `Provider` + `ChangeNotifier` per gestire lo stato
- `Helper` separato per le query al database
- UI semplice in stile consegna, senza funzionalità extra inutili

## Database
Tabelle usate:
- `cards` → contiene le note
- `todos` → contiene i promemoria collegati alla card (`card_id`)

## Dipendenze
- `provider`
- `sqflite`
- `path`

## Nota
L’app con `sqflite` va provata su Android/iOS/emulatore.  
Su Chrome SQLite non funziona direttamente.
