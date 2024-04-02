require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }

  it "is valid with valid attributes" do
    event = Event.new(name: "Test Event", date_time: DateTime.now, total_tickets: 100, user: user)
    expect(event).to be_valid
  end

  it "is not valid without a name" do
    event = Event.new(date_time: DateTime.now, total_tickets: 100, user: user)
    expect(event).to_not be_valid
  end

  it "is not valid without a date_time" do
    event = Event.new(name: "Test Event", total_tickets: 100, user: user)
    expect(event).to_not be_valid
  end

  it "is not valid without a total_tickets" do
    event = Event.new(name: "Test Event", date_time: DateTime.now, user: user)
    expect(event).to_not be_valid
  end

  it "is not valid without a user" do
    event = Event.new(name: "Test Event", date_time: DateTime.now, total_tickets: 100)
    expect(event).to_not be_valid
  end
end
