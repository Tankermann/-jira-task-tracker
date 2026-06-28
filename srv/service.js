const cds = require('@sap/cds');

function getISOWeek(dateStr) {
  const d = new Date(dateStr);
  const utc = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  const dayOfWeek = utc.getUTCDay() || 7;
  utc.setUTCDate(utc.getUTCDate() + 4 - dayOfWeek);
  const yearStart = new Date(Date.UTC(utc.getUTCFullYear(), 0, 1));
  return Math.ceil((((utc - yearStart) / 86400000) + 1) / 7);
}

module.exports = class TrackerService extends cds.ApplicationService {
  async init() {
    this.before(['CREATE', 'UPDATE'], 'WorkEntries', async (req) => {
      // Kalenderwoche aus Datum berechnen
      if (req.data.date) {
        req.data.calendarWeek = getISOWeek(req.data.date);
      }

      // Ticket-Beschreibung als Snapshot kopieren
      if (!req.data.ticketDescription && req.data.ticket_ID) {
        const ticket = await SELECT.one('description')
          .from('jira.tracker.Tickets')
          .where({ ID: req.data.ticket_ID });
        if (ticket?.description) {
          req.data.ticketDescription = ticket.description;
        }
      }

      // Buchungsnummer automatisch aus product + area + type auflösen
      if (req.data.product_ID && req.data.area && req.data.type) {
        const booking = await SELECT.one('ID')
          .from('jira.tracker.BookingNumbers')
          .where({ product_ID: req.data.product_ID, area: req.data.area, type: req.data.type });
        if (booking) {
          req.data.bookingNumber_ID = booking.ID;
        } else {
          req.error(400, `Keine Buchungsnummer für ${req.data.area} / ${req.data.type} bei diesem Produkt hinterlegt.`);
        }
      }
    });

    return super.init();
  }
};
