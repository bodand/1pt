class EventEntry < ApplicationRecord
  belongs_to :event
  has_many :response_entries

  def as_datetime
    msg = "#{date}T#{time.strftime('%H:%M:%S%z')}"
    DateTime.iso8601(msg)
  end
end
