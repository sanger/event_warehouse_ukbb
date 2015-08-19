class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :events,         :event_types
    add_foreign_key :metadata,       :events
    add_foreign_key :event_subjects, :events
    add_foreign_key :event_subjects, :subjects
    add_foreign_key :event_subjects, :role_types
    add_foreign_key :subjects,       :subject_types
  end
end
