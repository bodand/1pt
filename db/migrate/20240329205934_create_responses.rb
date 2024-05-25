class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses do |t|
      t.string :responder
      t.references :user, null: true, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
