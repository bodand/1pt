class Response < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  has_many :response_entries

  validates :user_id,
            presence: true,
            if: -> { responder.blank? }
  validates :responder,
            presence: true,
            format: { with: /\A[\p{L}\d .-]+\z/, message: I18n.t('errors.illegal_char') },
            if: -> { user_id.blank? }

  def responder_name
    if user
      user.name
    else
      responder
    end
  end
end
