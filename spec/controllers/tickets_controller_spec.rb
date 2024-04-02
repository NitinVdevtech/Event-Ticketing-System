require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event) }

  before do
    sign_in user
  end

  describe "POST #create" do
    # context "when user tries to book their own event's ticket" do
    #   before do
    #     user.events << event
    #     post :create, params: { event_id: event.id, quantity: 1 }
    #   end

    #   it "redirects back to event with an alert message" do
    #     expect(response).to redirect_to(event)
    #     expect(flash[:alert]).to eq("You can't book your Event's ticket")
    #   end
    # end

    # context "when user tries to book tickets with invalid quantity" do
    #   before do
    #     post :create, params: { event_id: event.id, quantity: 0 }
    #   end

    #   it "redirects to root path with an alert message" do
    #     expect(response).to redirect_to(root_path)
    #     expect(flash[:alert]).to eq("Invalid quantity.")
    #   end
    # end

    context "when user tries to book tickets for an event with enough availability" do
      before do
        allow(event).to receive(:available_tickets).and_return(5)
        post :create, params: { event_id: event.id, quantity: 3 }
      end

      it "creates a new ticket and redirects to root path with a notice message" do
        expect(user.tickets.count).to eq(1)
        expect(user.tickets.first.event).to eq(event)
        expect(user.tickets.first.quantity).to eq(3)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Tickets booked successfully.")
      end
    end

    context "when another user simultaneously tries to book tickets for the same event" do
      before do
        allow(event).to receive(:available_tickets).and_return(5)
        allow_any_instance_of(User).to receive(:tickets).and_raise(ActiveRecord::StaleObjectError)
        post :create, params: { event_id: event.id, quantity: 3 }
      end

      it "redirects back to event with an alert message" do
        expect(response).to redirect_to(event)
        expect(flash[:alert]).to eq("Another user has booked tickets for this event. Please try again.")
      end
    end
  end
end
