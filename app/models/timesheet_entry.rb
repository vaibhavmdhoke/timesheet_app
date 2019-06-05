class TimesheetEntry < ApplicationRecord
  validates :start_time, :finish_time, :entry_date, presence: true
  validate :timesheet_entries_validation
  before_save :dollar_value_calculation


  def timesheet_entries_validation
    return if start_time.nil? || finish_time.nil? || entry_date.nil?
    if start_time >= finish_time
      errors.add(:finish_time, 'Finish Time should not be before or equal to Start Time')
    elsif check_for_conflicts
      errors.add(:finish_time, 'Time Conflicts with other schedule')
      errors.add(:start_time, 'Time Conflicts with other schedule')
      puts "conflict found...."
    else
      true
    end
  end

  def dollar_value_calculation
    day = entry_date.strftime("%A").downcase
    case day
    when 'friday', 'monday', 'wednesday'
      self.amount = time_calculator(finish_time, start_time) * 22.0 # 22/hr
    when 'tuesday', 'thursday'
      self.amount = time_calculator(finish_time, start_time) * 25.0 # 22/hr
    else 
      self.amount = time_calculator(finish_time, start_time) * 47.0 # 22/hr
    end
  end


  def time_calculator(finish_time, start_time)
    (finish_time.to_f - start_time.to_f) / 3600.0
  end

  def check_for_conflicts
    entries = TimesheetEntry.where(entry_date: entry_date)
    return false if entries.nil?
    conflict_found = false
    entries.each do |entry|
    ## 1. check for conflicting
      if entry.start_time > start_time && start_time > entry.finish_time ## New Entry is in between
        conflict_found = true
        # errors.add(:start_time, "Time Conflicts with other schedule task, #{entry.task_name}, start")
      elsif entry.start_time > finish_time && finish_time > entry.finish_time
        conflict_found = true
        # errors.add(:finish_time, "Time Conflicts with other schedule task #{entry.task_name}, finish")
      elsif start_time > entry.start_time && entry.start_time > finish_time 
        conflict_found = true
        # errors.add(:finish_time, "Time Conflicts with other schedule task #{entry.task_name}, start ")
      elsif start_time > entry.finish_time && entry.finish_time > finish_time 
        conflict_found = true
        # errors.add(:finish_time, "Time Conflicts with other schedule task #{entry.task_name}, start ")
      end
    end
    conflict_found
  end

end
