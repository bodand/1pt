class ResponseEntry < ApplicationRecord
  ValidResponses = %w[ok maybe no]

  belongs_to :response
  belongs_to :event_entry

  validates :stat, presence: true,
            inclusion: { in: ValidResponses, message: I18n.t('errors.invalid_status') }
end
