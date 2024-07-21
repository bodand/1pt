class Response < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  has_many :response_entries

  validates :user,
            presence: true,
            if: -> { responder.blank? }
  validates :responder,
            presence: true,
            format: RealNameFormat,
            if: -> { user.blank? }

  def responder_name
    if user
      user.name
    else
      responder
    end
  end
end
