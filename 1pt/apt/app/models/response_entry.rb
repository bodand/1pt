class ResponseEntry < ApplicationRecord
  belongs_to :response
  belongs_to :event_entry
end
