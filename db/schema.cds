namespace jira.tracker;

using { cuid, managed } from '@sap/cds/common';

// ── Enums ───────────────────────────────────────────────────

type Priority : String(10) enum {
  low       = 'LOW';
  medium    = 'MEDIUM';
  high      = 'HIGH';
  very_high = 'VERY_HIGH';
}

type TicketSystem : String(20) enum {
  jira          = 'JIRA';
  urgent_change = 'URGENT_CHANGE';
  problem       = 'PROBLEM';
}

type BookingArea : String(15) enum {
  entwicklung = 'ENTWICKLUNG';
  beratung    = 'BERATUNG';
}

type BookingType : String(10) enum {
  run    = 'RUN';
  change = 'CHANGE';
}

// ── Stammdaten ──────────────────────────────────────────────

entity Products : cuid, managed {
  abbreviation   : String(10)  not null;
  description    : String(200) not null;
  tickets        : Composition of many Tickets       on tickets.product       = $self;
  bookingNumbers : Composition of many BookingNumbers on bookingNumbers.product = $self;
}

entity Tickets : cuid, managed {
  product      : Association to Products not null;
  system       : TicketSystem not null;
  ticketNumber : String(30)   not null;
  description  : LargeString;
  priority     : Priority;
  validUntil   : Date;
}

entity BookingNumbers : cuid, managed {
  product       : Association to Products not null;
  bookingNumber : String(30)  not null;
  area          : BookingArea not null;
  type          : BookingType not null;
  description   : String(200);
}

// ── Arbeitstracking ─────────────────────────────────────────

entity WorkEntries : cuid, managed {
  date              : Date        not null;
  calendarWeek      : Integer;               // auto aus date (Handler)
  product           : Association to Products      not null;
  ticket            : Association to Tickets       not null;
  ticketDescription : LargeString;           // Snapshot zum Erfassungszeitpunkt (Handler)
  area              : BookingArea not null;   // User-Input
  type              : BookingType not null;   // User-Input
  bookingNumber     : Association to BookingNumbers; // auto aus product+area+type (Handler)
  workDescription   : LargeString not null;
  timeFrom          : Time;
  timeTo            : Time;
}
