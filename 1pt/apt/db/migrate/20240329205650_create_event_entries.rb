class CreateEventEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :event_entries do |t|
      t.date :date
      t.time :time
      t.references :event

      t.timestamps
    end
  end
end
