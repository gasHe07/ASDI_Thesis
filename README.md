# Progetto di Architettura dei Sistemi Digitali (ASDI)

![VHDL](https://img.shields.io/badge/Language-VHDL-orange)
![Vivado](https://img.shields.io/badge/Tools-Xilinx%20Vivado-blue)
![FPGA](https://img.shields.io/badge/Hardware-Nexys%20A7--50T-red)
![University](https://img.shields.io/badge/University-Federico%20II-brightgreen)

## 👤 Autori
* **Elio Fava** 
* **Valentina Mauriello** 

**Docenti:** Prof. Nicola Mazzocca, Prof.ssa Alessandra De Benedictis  
**Corso di Laurea:** Ingegneria Informatica  
**Università degli Studi di Napoli Federico II** | **Anno Accademico:** 2025-2026

---

## 📝 Descrizione del Progetto
Questo repository raccoglie l'intero lavoro svolto per l'elaborato del corso di **Architettura dei Sistemi Digitali**. Il progetto consiste nella progettazione, implementazione in **VHDL** e validazione su board **FPGA Nexys A7-50T (Artix-7)** di diversi sistemi digitali complessi.

Il percorso documentato spazia dalle basi delle reti combinatorie fino alla micro-programmazione di un processore didattico, integrando simulazioni software e test su hardware reale.

---

## 🚀 Funzionalità Principali

### 1. Sistemi di Interconnessione
* **Rete 32-8:** Infrastruttura di comunicazione basata su una gerarchia di Multiplexer e Demultiplexer.
* **Gerarchia MUX:** Design di un Multiplexer 32:1 strutturato su 3 livelli logici con moduli base 2:1 e 8:1.

### 2. Macchine Sequenziali e FSM
* **Riconoscitori di Sequenze:** Implementazione di macchine a stati finiti (FSM) secondo i modelli di **Mealy** e **Moore**.
* **Registri Parametrici:** Sviluppo di Shift Register configurabili.

### 3. Sistemi Aritmetici e I/O
* **Cronometro Digitale:** Sistema di timing con gestione del debouncing dei pulsanti e visualizzazione su display a 7 segmenti.

### 4. Protocolli di Comunicazione
* **Handshaking:** Sistema di scambio dati tra nodi (A e B) sincronizzato tramite segnali `req` (request) e `ack` (acknowledge).
* **Interfaccia Seriale (UART/RS232):** Progettazione del sistema di trasmissione dati asincrona.
    > **⚠️ Nota Tecnica:** I file sorgente VHDL relativi all'esercizio sulla trasmissione seriale (UART) non sono inclusi nella repository in quanto i file originali sono andati corrotti. La trattazione teorica e i risultati dei test sono comunque consultabili nell'elaborato PDF allegato.

### 5. Reti Multistadio (MIN)
* **Omega Network 8x8:** Implementazione di una rete di interconnessione per l'instradamento di pacchetti con algoritmo di arbitraggio **Round Robin**.

### 6. Architettura del Processore (MIC-1)
* **Microprogrammazione:** Analisi dell'architettura e modifica del set di istruzioni originale (es. implementazione di `IADD`).
* **Simulazione:** La validazione del microcodice è stata effettuata tramite un simulatore dedicato in ambiente virtualizzato.
    > **ℹ️ Nota sulla VM:** I file relativi alla configurazione della Virtual Machine (VM) utilizzata per le simulazioni del MIC-1 non sono inclusi nella repository per motivi di dimensioni.

---

## 🛠️ Tecnologie e Tool Utilizzati

| Tecnologia | Descrizione |
| :--- | :--- |
| **Linguaggio** | VHDL (Behavioral, Dataflow, Structural) |
| **Tool di Sviluppo** | Xilinx Vivado Design Suite |
| **Virtualizzazione** | Oracle VM VirtualBox (per simulazione MIC-1) |
| **Hardware** | FPGA Nexys A7-50T/100T (Artix-7) |

---
