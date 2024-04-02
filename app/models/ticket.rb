class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :my_booked_tickets, -> {
    joins(:event)
      .group('events.id')
      .select('*, SUM(tickets.quantity) AS total_quantity')
  }

  # Add lock_version for optimistic locking
  self.ignored_columns = [:lock_version]
end
