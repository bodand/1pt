class ResponseEntry < ApplicationRecord
  belongs_to :response
  belongs_to :event_entry

  validates :stat, presence: true
end
