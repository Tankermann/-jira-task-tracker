# CLAUDE.md – jira-task-tracker

wiki_entry: KanpekiVault/wiki/projects/jira-task-tracker/

---

## Projektzweck

Persönliches Tool zum Tracken von Jira-Arbeiten mit Kontext. Jira-Ticketnummern (z. B. "ISE-1234") werden beim Erfassen mit Beschreibungstext, Zeitangabe und Freitext angereichert — sodass am Wochenende ein lesbarer Wochenbericht entsteht, ohne jede Nummer in Jira nachzuschlagen.

---

## Verzeichnisstruktur

```
jira-task-tracker/
├── CLAUDE.md           ← Diese Datei
├── package.json
├── db/
│   └── schema.cds      ← CDS-Datenmodell (Products, IseNumbers, WorkEntries)
├── srv/
│   ├── service.cds     ← OData-Service-Definition
│   └── service.js      ← Service-Handler (calendarWeek auto-befüllen)
└── app/                ← SAPUI5-Frontend (noch leer)
```

---

## Stack

- **Backend:** SAP CAP (Node.js), `@sap/cds` ^8
- **Datenbank:** SQLite lokal (`@cap-js/sqlite`), Datei: `db/tracker.db`
- **Frontend:** SAPUI5 (in `app/`)
- **Start:** `npm run dev` → `cds watch`

## Datenmodell (Überblick)

| Entität | Typ | Beschreibung |
|---------|-----|-------------|
| `Products` | Stammdaten | Produkt mit Kürzel + Beschreibung |
| `IseNumbers` | Stammdaten | ISE-Tickets, Kind von Products (1:n) |
| `WorkEntries` | Tracking | Erbrachte Arbeit pro Tag/Task |

Vollständiges Modell: `db/schema.cds`

---

## Zugriffsregeln

**Bei Dokumentationsaufgaben:** Nur lesen. Doku nach `KanpekiVault/wiki/projects/jira-task-tracker/`.

**Bei Code-Aufgaben:** Voller Lese- und Schreibzugriff auf alle Dateien.

---

## Operationen

### DEV-START
`npm run dev` — startet `cds watch`, auto-reload bei Dateiänderungen.
OData-Endpoint: `http://localhost:4004/tracker`

### DB-RESET
`cds deploy --to sqlite` — Schema neu deployen (löscht vorhandene Daten).

### DOKU-UPDATE
**Aufruf:** `/doku-update jira-task-tracker`
1. `db/schema.cds` und `srv/` lesen
2. Wiki-Seiten in `KanpekiVault/wiki/projects/jira-task-tracker/` aktualisieren
