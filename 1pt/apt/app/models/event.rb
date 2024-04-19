class Event < ApplicationRecord
  belongs_to :user
  has_many :responses
  has_many :event_entries

  validates :name, presence: true
end
