# CLAUDE.md – jira-task-tracker

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

### DEV-START
`npm run dev` — startet `cds watch`, auto-reload bei Dateiänderungen.
OData-Endpoint: `http://localhost:4004/tracker`

### DB-RESET
`cds deploy --to sqlite:db/tracker.db` — Schema neu deployen (löscht vorhandene Daten).
