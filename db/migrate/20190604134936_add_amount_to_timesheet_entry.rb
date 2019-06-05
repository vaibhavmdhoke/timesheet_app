class AddAmountToTimesheetEntry < ActiveRecord::Migration[5.0]
  def change
    add_column :timesheet_entries, :amount, :float
  end
end
