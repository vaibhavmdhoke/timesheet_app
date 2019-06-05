class TimesheetEntry < ApplicationRecord
  validates :start_time, :finish_time, :entry_date, presence: true
  validate :timesheet_entries_validation
  before_save :dollar_value_calculation
  ##  validation TODO: date should not be after todays date remaining & time remaininf

  def timesheet_entries_validation
    return if start_time.nil? || finish_time.nil? || entry_date.nil?
    if start_time >= finish_time
      errors.add(:finish_time, 'Finish Time should not be before or equal to Start Time')
    elsif check_for_conflicts
      # binding.pry
      errors.add(:finish_time, 'Time Conflicts with other schedule')
      errors.add(:start_time, 'Time Conflicts with other schedule')
    else
      true
    end
  end

  def dollar_value_calculation
    day = entry_date.strftime('%A').downcase
    case day
    when 'friday', 'monday', 'wednesday'
      self.amount = calculate_amount_per_entry(22.0, 33.0, Time.utc(2000, 01, 01, 07,00), Time.utc(2000, 01, 01, 19,00))
    when 'tuesday', 'thursday'
      self.amount = calculate_amount_per_entry(25.0, 35.0, Time.utc(2000, 01, 01, 05,00), Time.utc(2000, 01, 01, 17,00))
    else
      self.amount = time_calculator(finish_time, start_time) * 47.0
    end
  end

  def calculate_amount_per_entry(base_rate, outside_base_rate, lower_limit_time, upper_limit_time)
    amount = 0
    if start_time.to_i > lower_limit_time.to_i && finish_time.to_i < upper_limit_time.to_i
      amount = time_calculator(finish_time, start_time) * base_rate
    elsif start_time.to_i < lower_limit_time.to_i && finish_time.to_i < upper_limit_time.to_i
      amount = time_calculator(lower_limit_time, start_time) * outside_base_rate
      amount += time_calculator(finish_time, lower_limit_time) * base_rate
    elsif start_time.to_i > lower_limit_time.to_i && finish_time.to_i > upper_limit_time.to_i
      amount = time_calculator(upper_limit_time, start_time) * base_rate
      amount += time_calculator(finish_time, upper_limit_time) * outside_base_rate
    elsif start_time.to_i < lower_limit_time.to_i && finish_time.to_i > upper_limit_time.to_i
      amount = time_calculator(lower_limit_time, start_time) * outside_base_rate
      amount += time_calculator(upper_limit_time, lower_limit_time) * base_rate
      amount += time_calculator(finish_time, upper_limit_time) * outside_base_rate
    end
    amount
  end

  def time_calculator(finish_time, start_time)
    (finish_time.to_f - start_time.to_f) / 3600.0
  end

  def check_for_conflicts
    entries = TimesheetEntry.where(entry_date: entry_date).where.not(id: self.id)
    return false if entries.nil?
    conflict_found = false
    entries.each do |entry|
    ## 1. check for conflicting
      if entry.start_time > start_time && start_time < entry.finish_time ## New Entry is in between
        conflict_found = true
        errors.add(:start_time, "Time Conflicts with other schedule task, #{entry.task_name}, start")
      elsif entry.start_time > finish_time && finish_time < entry.finish_time
        conflict_found = true
        errors.add(:finish_time, "Time Conflicts with other schedule task #{entry.task_name}, finish")
      elsif start_time > entry.start_time && entry.start_time < finish_time 
        conflict_found = true
        errors.add(:finish_time, "Time Conflicts with other schedule task #{entry.task_name}, start ")
      elsif start_time > entry.finish_time && entry.finish_time < finish_time 
        conflict_found = true
        errors.add(:finish_time, "Time Conflicts with other schedule task #{entry.task_name}, start ")
      end
    end
    conflict_found
  end

end
