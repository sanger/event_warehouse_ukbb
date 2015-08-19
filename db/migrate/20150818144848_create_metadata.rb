class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.integer :event_id, comment:'References the event with which the metadata is associated'
      t.string :key, comment:'The metadata type'
      t.string :value, comment:'The metadata value'
      t.timestamps
    end
  end
end
