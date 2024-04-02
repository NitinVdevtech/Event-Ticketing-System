class TicketsController < ApplicationController
    before_action :authenticate_user!

    def create
      @event = Event.find(params[:event_id])
      # if current_user.events.include? @event
      #   redirect_to @event, alert: "You can't book your Event's ticket"
      #   return
      # end
      quantity = params[:quantity].to_i
      if quantity <= 0
        redirect_to root_path, alert: 'Invalid quantity.'
        return
      end

      begin
        Ticket.transaction do
          tickets_available = @event.available_tickets
          if quantity > tickets_available
            raise ArgumentError, 'Not enough tickets available.'
          end

          current_user.tickets.create!(event: @event, quantity: quantity)
        end

        redirect_to root_path, notice: 'Tickets booked successfully.'
      rescue ArgumentError => e
        redirect_to @event, alert: e.message
      rescue ActiveRecord::StaleObjectError
        redirect_to @event, alert: 'Another user has booked tickets for this event. Please try again.'
      end
    end
  end
