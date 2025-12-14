# Chatroom

Sviluppatore: Hadi Hammoud  
Classe: 5IE

## Descrizione

Applicazione chatroom sviluppata in Dart e Flutter che permette a più utenti di comunicare tramite messaggi di testo. Il sistema è composto da un server TCP, un client testuale e un client mobile. Ogni messaggio è visualizzato nel formato user: msg.

## Componenti

Server TCP: gestisce le connessioni multiple dei client sulla porta 3000, richiede il nome utente al momento della connessione e gestisce la comunicazione broadcast tra tutti i client connessi.

Client Testuale: client da riga di comando che si connette al server, permette l'inserimento del nome utente e l'invio di messaggi tramite input da terminale.

Client Mobile: versione mobile del client testuale sviluppata in Flutter con interfaccia grafica, mantiene lo stesso protocollo di comunicazione del client testuale.

## Funzionamento

Il client si connette al server sulla porta 3000 e il server richiede subito il nome utente. Il client invia il nome come primo messaggio e il server conferma la registrazione. Dopo la registrazione l'utente può iniziare a chattare. I messaggi inviati vengono trasmessi a tutti gli altri client connessi nel formato username: messaggio. Per disconnettersi si usa il comando exit1.

## Protocollo

Connessione TCP su porta 3000 con codifica UTF-8 per i messaggi. Ogni messaggio termina con \n. Il primo messaggio dopo la connessione è lo username, i messaggi successivi sono il contenuto della chat.

## Scelte di Sviluppo

Architettura Client-Server: il server usa ServerSocket.bind per accettare connessioni multiple e gestisce l'associazione username-socket tramite Map. I messaggi vengono inviati in broadcast a tutti i client eccetto il mittente.

Gestione Stato Client Mobile: la variabile _usernameSet distingue la fase di login dalla fase chat, _messages mantiene lo storico messaggi e Socket.listen gestisce la ricezione asincrona dei messaggi dal server. Il TextField cambia dinamicamente l'hint in base allo stato.

Comunicazione: stream di dati binari decodificati in UTF-8, socket.write() e socket.flush() per l'invio dei messaggi, gestione errori con onError e onDone sul listener, chiusura pulita della connessione con socket.close().

Ottimizzazioni: trim sui messaggi per evitare invii vuoti, skip di messaggi vuoti per ridurre traffico di rete, dispose corretto di socket per prevenire memory leak.