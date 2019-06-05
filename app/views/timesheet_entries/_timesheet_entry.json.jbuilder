json.extract! timesheet_entry, :id, :task_name, :entry_date, :start_time, :finish_time, :amount, :created_at, :updated_at
json.url timesheet_entry_url(timesheet_entry, format: :json)
