class Event < ApplicationRecord
  belongs_to :user
  has_many :responses
  has_many :event_entries

  validates :name,
            presence: true,
            length: { in: 2..255 },
            format: { with: /\A[\p{L}\d <>{}()\[\]@&\#$€|'"_+-]+\z/, message: I18n.t('errors.illegal_char') }
end
