# Chrono

**Sviluppatore:** Hadi Hammoud  
**Classe:** 5IE

---

## Descrizione

Cronometro digitale sviluppato in Flutter con precisione al decimo di secondo. L'applicazione utilizza Stream collegati tramite pipe per gestire gli eventi temporali e permette di avviare, fermare, mettere in pausa e resettare il conteggio tramite due Floating Action Button dinamici.

---

## Funzionamento

- Display formato MM:SS.D con font monospace
- Bottone principale (destra): START (verde) → STOP (rosso) → RESET (blu)
- Bottone pausa (sinistra): PAUSE/RESUME (arancione)
- Aggiornamento ogni 100ms per visualizzazione fluida
- Pausa mantiene il tempo corrente, reset riporta a 00:00.0

---

## Scelte di Sviluppo

**Architettura Stream e Pipe**

- tickStream emette ogni 100ms (1 decimo)
- secStream riceve dopo 10 tick tramite pipe dimostrando la correlazione tra stream
- Variabile `_decimi` come unità base per semplificare calcoli di minuti, secondi e decimi

**Gestione Stato**

- Tre stati per bottone principale (START/STOP/RESET) gestiti da `_buttonState`
- Flag `_isPaused` separato per gestire pausa senza fermare definitivamente
- setState su ogni tick per aggiornamento real-time dei decimi

**Ottimizzazioni**

- Timer.periodic non ricreato in pausa, solo skip con `return` per efficienza
- Colori e icone dinamici sui bottoni per feedback visivo immediato
- Dispose corretto di timer e stream per prevenire memory leak
- heroTag distinti per gestione multipli FloatingActionButton
