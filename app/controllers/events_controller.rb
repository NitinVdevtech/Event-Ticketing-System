class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event , except: [:create, :index, :new]

  def index
    if user_signed_in?
      @my_booked_events = current_user.events.booked_tickets
      @my_booked_tickets = current_user.tickets.my_booked_tickets
      @events = Event.ordered_by_user(current_user.id).booked_tickets
    else
      @events = Event.all
    end
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    event = current_user.events.build(event_params)
    if event.save
      redirect_to event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully destroyed'
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :date_time, :total_tickets)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
