To-Do List

Sviluppatore: Hammoud Hadi
Classe: 5IE

Descrizione
Applicazione To-Do List sviluppata in Dart e Flutter che permette all’utente di gestire una lista di attività personali. L’app consente di aggiungere nuovi promemoria e visualizzarli in tempo reale tramite un’interfaccia semplice e intuitiva.

Componenti
	•	Main App: inizializza l’applicazione Flutter e definisce il tema grafico
	•	Model: rappresenta il singolo elemento Todo
	•	Notifier (ChangeNotifier + Provider): gestisce lo stato della lista e notifica automaticamente le modifiche all’interfaccia
	•	Widgets: componenti grafici per la visualizzazione dei Todo nella lista

Funzionamento
All’avvio dell’app viene mostrata la lista delle attività.
Premendo il Floating Action Button (+) si apre una finestra di dialogo che permette di inserire il testo del nuovo Todo.
Una volta confermato, l’elemento viene aggiunto alla lista e visualizzato immediatamente.

Scelte di Sviluppo
	•	Utilizzo di Provider per una gestione dello stato semplice ed efficiente
	•	ListView.builder per una visualizzazione dinamica e performante della lista
	•	AlertDialog per l’inserimento dei nuovi elementi
	•	Struttura modulare del codice per facilitare manutenzione e leggibilità
