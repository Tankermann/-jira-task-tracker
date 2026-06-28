# Project State: Jira Task Tracker

Last updated: 2026-06-28

---

## Implemented

- [x] **Products** — CRUD via OData (`/tracker/Products`)
- [x] **Tickets** — JIRA, URGENT_CHANGE, PROBLEM; Composition unter Products; Priority-Enum (low/medium/high/very_high); validUntil-Datum
- [x] **BookingNumbers** — per Produkt, kategorisiert nach Area (ENTWICKLUNG/BERATUNG) × Type (RUN/CHANGE); Composition unter Products
- [x] **WorkEntries** — Kern-Tracking-Entität mit 3 automatischen Handlern:
  - `calendarWeek` — ISO-8601-Kalenderwoche wird automatisch aus `date` berechnet und gespeichert
  - `ticketDescription` — Snapshot aus Tickets beim Erstellen (historisch stabil, kein JOIN nötig)
  - `bookingNumber` — automatische Auflösung aus `product + area + type` (User gibt keine FK-ID ein)

## Open / Planned

- [ ] **SAPUI5-Frontend** (`app/`) — Views: Stammdatenpflege, WorkEntry-Erfassung, Wochenübersicht
- [ ] **Wochenbericht Export** — manuell oder per Ollama-Zusammenfassung (→ ideas.md)
- [ ] **Unique Constraint BookingNumbers** — `(product, area, type)` auf DB-Ebene erzwingen
- [ ] **Ollama-Integration** — Custom Action `summarizeWeek` (Idee, noch nicht beschlossen)

## Data Model

```
Products        abbreviation, description
  └── Tickets   system (JIRA|URGENT_CHANGE|PROBLEM), ticketNumber, description, priority, validUntil
  └── BookingNumbers  bookingNumber, area (ENTWICKLUNG|BERATUNG), type (RUN|CHANGE), description

WorkEntries     date, calendarWeek*, product→, ticket→, ticketDescription*, area, type,
                bookingNumber→*, workDescription, timeFrom, timeTo
                (* = auto-gesetzt durch Handler)
```

## Key Commands

```bash
npm run dev                          # cds watch, Reload bei Änderungen
cds deploy --to sqlite:db/tracker.db # Schema neu deployen (löscht Daten)
```

OData-Endpoint: `http://localhost:4004/tracker`

## Current Priorities

1. SAPUI5-App-Struktur in `app/` aufbauen
2. Unique Constraint für BookingNumbers (product + area + type)
3. Wochenbericht-Export

## Known Issues (Kurzform)

- SQLite: kein Multi-User (Single-User-Tool, by design)
- BookingNumbers: kein DB-seitiger Unique Constraint (Tech Debt)
- Keine Authentifizierung (lokales Tool, by design)
- ticketDescription-UPDATE: Snapshot wird bei UPDATE nicht automatisch aktualisiert

## Git

- Remote: `git@github.com:Tankermann/-jira-task-tracker.git`
- Branches: `main` (stable), `dev` (working), `feat/*` (features)
