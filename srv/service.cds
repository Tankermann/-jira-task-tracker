using jira.tracker as db from '../db/schema';

service TrackerService @(path: '/tracker') {
  entity Products       as projection on db.Products;
  entity Tickets        as projection on db.Tickets;
  entity BookingNumbers as projection on db.BookingNumbers;
  entity WorkEntries    as projection on db.WorkEntries;
}
