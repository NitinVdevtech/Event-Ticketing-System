FactoryBot.define do
    factory :event do
      name { "Test Event" }
      date_time { DateTime.now }
      total_tickets { 100 }
      user
    end
  end
