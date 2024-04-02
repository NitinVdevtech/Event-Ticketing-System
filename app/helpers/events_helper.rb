module EventsHelper
  def booked_tickets_count(user, event)
      event.tickets.booked_tickets(user, event)
  end
end
