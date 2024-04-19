class Response < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  has_many :response_entries

  def responder_name
    if user
      user.name
    else
      responder
    end
  end
end
