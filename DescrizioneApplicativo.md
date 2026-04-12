# SubitoGusto - Descrizione Applicativo

## Panoramica

**SubitoGusto** è un'applicazione moderna per la gestione degli ordini al tavolo tramite QR code. L'obiettivo principale è migliorare l'esperienza dei clienti e ottimizzare il lavoro del personale di sala, riducendo i tempi di attesa e gli errori nella presa delle comande.

---

## Come Funziona

### Per il Cliente

1. **Scansione QR Code**
   Il cliente si siede al tavolo e trova un QR code posizionato sul tavolo o sul menu. Scansionando il codice con il proprio smartphone, accede direttamente al menu digitale del ristorante.

2. **Consultazione del Menu**
   Il menu viene visualizzato in modo chiaro e organizzato per categorie:
   - Antipasti
   - Primi Piatti
   - Secondi Piatti
   - Contorni
   - Dolci
   - Bevande

   Ogni piatto mostra nome, descrizione, prezzo e eventuali indicazioni per allergeni o preferenze alimentari (vegetariano, vegano, senza glutine, piccante).

3. **Selezione dei Piatti**
   Il cliente può sfogliare le categorie, filtrare i piatti e aggiungere quelli desiderati al proprio carrello virtuale.

4. **Invio dell'Ordine**
   Una volta completata la selezione, il cliente conferma l'ordine che viene inviato direttamente in cucina e al personale di sala.

5. **Monitoraggio in Tempo Reale**
   Il cliente può vedere lo stato del proprio ordine in tempo reale:
   - In attesa di conferma
   - Confermato
   - In preparazione
   - Pronto per essere servito

---

### Per il Personale

1. **Dashboard Ordini**
   Il personale di sala e cucina ha accesso a una dashboard che mostra tutti gli ordini attivi in tempo reale. Gli ordini appaiono automaticamente appena vengono inviati dai clienti.

2. **Gestione Stati Ordine**
   Il personale può aggiornare lo stato di ogni ordine man mano che procede:
   - Confermare la ricezione
   - Segnalare l'inizio della preparazione
   - Indicare quando il piatto è pronto

3. **Gestione Menu**
   L'amministratore può:
   - Aggiungere, modificare o rimuovere piatti dal menu
   - Creare e organizzare le categorie
   - Impostare la disponibilità dei piatti (utile quando un ingrediente è esaurito)
   - Caricare foto dei piatti

4. **Gestione Tavoli**
   È possibile configurare i tavoli del ristorante, ognuno con il proprio QR code univoco. Questo permette di sapere sempre da quale tavolo proviene ogni ordine.

---

## Vantaggi Principali

### Per il Ristorante

- **Riduzione errori**: Gli ordini arrivano scritti direttamente dal cliente, eliminando incomprensioni
- **Maggiore efficienza**: Il personale non deve spostarsi per prendere le comande
- **Aggiornamenti istantanei**: Cambio prezzi o disponibilità immediati su tutti i tavoli
- **Risparmio carta**: Niente più menu cartacei da ristampare
- **Dati e statistiche**: Possibilità di analizzare quali piatti sono più richiesti

### Per il Cliente

- **Autonomia**: Ordina quando vuole, senza aspettare il cameriere
- **Chiarezza**: Vede foto, descrizioni e prezzi di ogni piatto
- **Trasparenza**: Sa sempre a che punto è il suo ordine
- **Comodità**: Usa il proprio smartphone, già familiare
- **Informazioni allergeni**: Identifica facilmente piatti adatti alle proprie esigenze

---

## Caratteristiche del Menu Digitale

### Organizzazione per Categorie
I piatti sono raggruppati in categorie (Antipasti, Primi, Secondi, ecc.) con possibilità di filtrare velocemente.

### Scheda Piatto
Ogni piatto include:
- Nome
- Descrizione degli ingredienti
- Prezzo
- Foto (quando disponibile)
- Indicazioni dietetiche (vegetariano, vegano, senza glutine)
- Avvisi allergeni
- Tempo di preparazione stimato

### Icone e Simboli
Per facilitare la lettura, vengono utilizzati simboli intuitivi:
- 🥬 Vegetariano
- 🌱 Vegano
- 🌾 Senza Glutine
- 🌶️ Piccante
- ⭐ Consigliato dallo Chef

---

## Flusso dell'Ordine

```
Cliente scansiona QR
        ↓
Visualizza menu sul telefono
        ↓
Aggiunge piatti al carrello
        ↓
Conferma ordine
        ↓
Ordine arriva in dashboard staff
        ↓
Staff conferma ricezione
        ↓
Cucina prepara i piatti
        ↓
Staff segna "Pronto"
        ↓
Cliente viene servito
```

---

## Interfacce

### Versione Cliente (Mobile)
Ottimizzata per smartphone, con:
- Design pulito e leggibile
- Navigazione semplice con gesti touch
- Caricamento veloce anche con connessione lenta
- Nessuna app da scaricare (funziona dal browser)

### Versione Staff (Desktop/Tablet)
Pensata per la gestione, con:
- Vista panoramica di tutti gli ordini
- Gestione completa del menu
- Configurazione tavoli e QR code
- Accesso riservato con credenziali

---

## Design e Stile

L'applicazione adotta uno stile elegante e raffinato, in linea con l'atmosfera di un ristorante di qualità:

- **Colori principali**: Bordeaux e oro, che richiamano il mondo del vino e della ristorazione di classe
- **Sfondo**: Tonalità crema calde e accoglienti
- **Tipografia**: Leggibile e sofisticata
- **Immagini**: Foto dei piatti in alta qualità

---

## Requisiti per l'Utilizzo

### Per i Clienti
- Smartphone con fotocamera (per scansione QR)
- Connessione internet (WiFi del ristorante o dati mobili)
- Browser web moderno (Chrome, Safari, Firefox)

### Per il Personale
- Computer, tablet o smartphone
- Connessione internet
- Credenziali di accesso fornite dall'amministratore

---

## Sicurezza e Privacy

- I dati degli ordini sono protetti e accessibili solo al personale autorizzato
- Non vengono raccolti dati personali dei clienti oltre a quelli necessari per l'ordine
- Ogni ristorante ha accesso solo ai propri dati (sistema multi-tenant)
- Le comunicazioni sono crittografate

---

## Supporto Multi-Ristorante

L'applicativo è predisposto per gestire più ristoranti in modo indipendente. Ogni ristorante ha:
- Il proprio menu personalizzato
- I propri tavoli e QR code
- Il proprio personale con credenziali dedicate
- I propri dati separati dagli altri

---

## Conclusione

**SubitoGusto** rappresenta un passo avanti nella digitalizzazione del servizio di ristorazione, mantenendo però il calore e l'attenzione al cliente tipici della tradizione italiana. L'obiettivo non è sostituire il rapporto umano tra cameriere e cliente, ma liberare tempo prezioso che il personale può dedicare a un servizio ancora più attento e personalizzato.

---

*Sviluppato con tecnologie moderne per garantire velocità, affidabilità e facilità d'uso.*
