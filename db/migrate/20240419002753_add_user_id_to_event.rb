class AddUserIdToEvent < ActiveRecord::Migration[7.1]
  def change
    add_reference :events, :user, index: true
  end
end
