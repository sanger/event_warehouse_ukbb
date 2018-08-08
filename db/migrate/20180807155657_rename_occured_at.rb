class RenameOccuredAt < ActiveRecord::Migration
  def change
    rename_column :events, :occured_at, :occurred_at
  end
end
