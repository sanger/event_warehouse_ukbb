class CreateEventSubjects < ActiveRecord::Migration
  def change
    create_table :event_subjects do |t|
      t.integer :event_id, comment:'Associate with the event (what happened)', index: true
      t.integer :subject_id, comment:'Associate with the subject (what it happened to, or what might care)', index: true
      t.integer :role_type_id, comment:'References the role_types table, describing the role'
      t.timestamps
    end
  end
end
