class CreateResponseEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :response_entries do |t|
      t.string :stat
      t.references :response, null: false, foreign_key: true
      t.references :event_entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
