class Event < ApplicationRecord
  belongs_to :user
  has_many :tickets, dependent: :destroy

  validates :name, :date_time, :total_tickets, presence: true

  scope :ordered_by_user, ->(user_id) {
    order(Arel.sql("CASE WHEN events.user_id = ? THEN 0 ELSE 1 END, created_at", user_id))
  }

  scope :booked_tickets, ->{
    joins(:tickets)
      .group(:event_id)
      .select("events.*, SUM(tickets.quantity) AS quantity")
  }

  def available_tickets
    total_tickets - tickets.sum(:quantity)
  end

end
