require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  let(:event) { Event.create(name: 'Test Event', date_time: DateTime.now, total_tickets: 100, user: user) }

  it "is valid with valid attributes" do
    ticket = Ticket.new(quantity: 2, user: user, event: event)
    expect(ticket).to be_valid
  end

  it "is not valid without a quantity" do
    ticket = Ticket.new(user: user, event: event)
    expect(ticket).to_not be_valid
  end

  it "is not valid with non-integer quantity" do
    ticket = Ticket.new(quantity: 1.5, user: user, event: event)
    expect(ticket).to_not be_valid
  end

  it "is not valid with zero quantity" do
    ticket = Ticket.new(quantity: 0, user: user, event: event)
    expect(ticket).to_not be_valid
  end

  it "is not valid with negative quantity" do
    ticket = Ticket.new(quantity: -1, user: user, event: event)
    expect(ticket).to_not be_valid
  end
end
