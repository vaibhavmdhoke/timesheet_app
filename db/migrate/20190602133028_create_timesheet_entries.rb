class CreateTimesheetEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :timesheet_entries do |t|
      t.string :task_name
      t.date :entry_date
      t.time :start_time
      t.time :finish_time

      t.timestamps
    end
  end
end
