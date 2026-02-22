# ZKEEP
Sviluppatore: [Hadi Hammoud]   //FORZA INTERRRRR 
Classe: 5IE

## Descrizione 
L'idea è avere più note (card) e dentro ogni nota una lista di promemoria (todo) da spuntare.
Ho usato SQLite per salvare i dati in locale, così quando riapro l'app le note restano.

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
  `Provider` + ChangeNotifier per gestire lo stato
  `DatabaseHelper` separato per tutte le query al database
  UI in stile consegna, senza funzionalità extra

## Database
  Tabelle usate:

  `notes` → contiene le note (card)
  `todos` → contiene i promemoria collegati alla nota (note_id)

## Dipendenze
- `provider`
- `sqflite`
- `path`

## Nota
L’app con `sqflite` va provata su Android/iOS/emulatore.  
Su Chrome SQLite non funziona direttamente.
