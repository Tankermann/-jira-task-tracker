# Jira Task Tracker

Tool zum Tracken von Jira-Arbeiten mit Kontext. Ticketnummern (z. B. "ISE-1234") werden beim Erfassen mit Beschreibungstext, Zeitangabe und Freitext angereichert — sodass am Wochenende ein lesbarer Wochenbericht entsteht, ohne jede Nummer nachzuschlagen.

## Stack

- **Backend:** SAP CAP (Node.js), `@sap/cds` ^8
- **Datenbank:** SQLite lokal (`db/tracker.db`)
- **Frontend:** SAPUI5 (in `app/`)

## Voraussetzungen

- Node.js >= 18
- `npm install`

## App starten

```bash
npm run dev
```

Startet `cds watch` mit Auto-Reload bei Dateiänderungen.
OData-Endpoint: `http://localhost:4004/tracker`

## Datenbank zurücksetzen

```bash
cds deploy --to sqlite:db/tracker.db
```

Deployt das Schema neu — **löscht vorhandene Daten.**

## Projektstruktur

```
jira-task-tracker/
├── db/
│   ├── schema.cds        ← Datenmodell
│   └── data/             ← Sample-Daten (CSV)
├── srv/
│   ├── service.cds       ← OData-Service /tracker
│   └── service.js        ← Handler (calendarWeek, ticketDescription, bookingNumber)
└── app/                  ← SAPUI5-Frontend (in Entwicklung)
```
