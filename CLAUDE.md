# CLAUDE.md – jira-task-tracker

Aktuellen Projektstand lesen: @.claude/project-state.md

**Nach Änderungen:** `/doku-update jira-task-tracker` ausführen → aktualisiert project-state.md + Wiki.

---

## Projektzweck

Tool zum Tracken von Jira-Arbeiten mit Kontext. Ticketnummern (z. B. "ISE-1234") werden beim Erfassen mit Beschreibungstext, Zeitangabe und Freitext angereichert — sodass am Wochenende ein lesbarer Wochenbericht entsteht, ohne jede Nummer nachzuschlagen.

---

## Verzeichnisstruktur

```
jira-task-tracker/
├── CLAUDE.md
├── package.json
├── db/
│   ├── schema.cds          ← CDS-Datenmodell
│   └── data/               ← Sample-Daten (CSV)
├── srv/
│   ├── service.cds         ← OData-Service /tracker
│   └── service.js          ← Handler (calendarWeek, ticketDescription, bookingNumber)
└── app/                    ← SAPUI5-Frontend
```

---

## Stack

- **Backend:** SAP CAP (Node.js), `@sap/cds` ^8
- **Datenbank:** SQLite lokal (`@cap-js/sqlite`), Datei: `db/tracker.db`
- **Frontend:** SAPUI5 (in `app/`)

## Datenmodell (Überblick)

| Entität | Typ | Beschreibung |
|---------|-----|-------------|
| `Products` | Stammdaten | Produkt mit Kürzel + Beschreibung |
| `Tickets` | Stammdaten | Tickets (JIRA / Urgent Change / Problem), Kind von Products |
| `BookingNumbers` | Stammdaten | Buchungsnummern pro Produkt, kategorisiert nach Area × Type |
| `WorkEntries` | Tracking | Erbrachte Arbeit pro Tag/Task |

Vollständiges Modell: `db/schema.cds`

---

## Operationen

Befehle zum Starten und Zurücksetzen: siehe `README.md`.

---

## Development Guidelines

*Abgeleitet von Karpathy's LLM-Coding-Prinzipien, Prinzip 4 mit BDD erweitert.*

### 1. Think Before Coding

**Nicht annehmen. Verwirrung nicht verstecken. Tradeoffs benennen.**

- Annahmen explizit nennen — bei Unsicherheit fragen, nicht raten
- Mehrere Interpretationen vorlegen, nicht still eine wählen
- Einfachere Alternative ansprechen wenn sie existiert
- Bei Unklarheit: stoppen, benennen was unklar ist, fragen

### 2. Simplicity First

**Minimaler Code der das Problem löst. Nichts Spekulatives.**

- Keine Features die nicht explizit gefragt wurden
- Keine Abstraktionen für Single-Use-Code
- Keine Flexibilität oder Konfigurierbarkeit die nicht verlangt wurde
- Wenn 200 Zeilen auch 50 sein könnten: neu schreiben

### 3. Surgical Changes

**Nur anfassen was muss. Nur den eigenen Mess aufräumen.**

- Keine "Verbesserungen" an angrenzendem Code, Kommentaren oder Formatierung
- Stil des bestehenden Codes matchen, auch wenn man es anders machen würde
- Ungenutzten Code der durch eigene Änderungen entstand: entfernen
- Pre-existing dead code: erwähnen, nicht löschen

### 4. Goal-Driven Execution mit BDD

**Akzeptanzkriterien zuerst. Zwei Ebenen. Loop bis grün.**

Jede Aufgabe in zwei Ebenen übersetzen:

**Ebene 1 — Acceptance Test (außen, business-lesbar):**
```
Given [Ausgangszustand]
When  [Aktion]
Then  [erwartetes Ergebnis]
```
→ Zuerst schreiben. Bleibt rot bis Ebene 2 fertig.

**Ebene 2 — TDD-Loop (innen, technisch):**
```
Failing Unit Test → minimaler Code → Refactor
Wiederholen bis Acceptance Test grün wird.
```

Beispiele für dieses Projekt:

| Aufgabe | Acceptance-Kriterium |
|---------|---------------------|
| Validation hinzufügen | Given WorkEntry ohne `date` / When POST / Then 400 + Fehlermeldung |
| Bug fixen | Given reproduzierender Test (rot) / When Fix / Then grün |
| Handler ändern | Given Tests grün vorher / When Refactor / Then Tests grün nachher |

Bei Mehrstufigen Tasks kurz planen:
```
1. [Schritt] → verify: [Check]
2. [Schritt] → verify: [Check]
```
