class EventEntry < ApplicationRecord
  belongs_to :event
  has_many :response_entries

  validates :date, presence: true, if: -> { time.blank? }
  validates :time, presence: true, if: -> { date.blank? }

  def as_datetime
    used_date = date || Date.ordinal(1970)
    used_time = time || Time.at(0)
    msg = "#{used_date}T#{used_time.strftime('%H:%M:%S%z')}"
    DateTime.iso8601(msg)
  end

  def as_rendered
    return I18n.l(as_datetime, format: :long) if date.present? && time.present?
    return I18n.l(date, format: :long) if date.present?
    return I18n.l(time, format: :time) if time.present?
    'Unknown date'
  end
end
