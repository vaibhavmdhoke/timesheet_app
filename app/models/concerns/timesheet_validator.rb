class TimesheetValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_time.nil? || record.finish_time.nil? || record.entry_date.nil?
    timesheet_entries_validation(record)
	end

	def timesheet_entries_validation(record)
    default_start_time = start_time_modifier(record)
    default_finish_time = finish_time_modifier(record)
    if default_start_time >= default_finish_time
      record.errors.add(:finish_time, 'should not be before or equal to Start Time')
    elsif default_finish_time > Time.now
      record.errors.add(:finish_time, 'cannot be in future')
    elsif default_start_time > Time.now
      record.errors.add(:start_time, 'cannot be in future')
    elsif check_for_conflicts(record, default_start_time, default_finish_time)
      record.errors.add(:finish_time, 'conflicts with other schedule')
      record.errors.add(:start_time, 'conflicts with other schedule')
    else
      true
    end
  end

  def check_for_conflicts(record, default_start_time, default_finish_time)
    entries = TimesheetEntry.where(entry_date: record.entry_date).where.not(id: record.id)
    return false if entries.nil?

    conflict_found = false
    entries.each do |entry|
      entry_start_time = start_time_modifier(entry)
      entry_finish_time = finish_time_modifier(entry)
      if default_start_time < entry_start_time && entry_start_time < default_finish_time
        conflict_found = true
      elsif default_start_time < entry_finish_time && entry_finish_time < default_finish_time
        conflict_found = true
      elsif default_start_time < entry_start_time && entry_start_time < default_finish_time
        conflict_found = true
      elsif default_start_time < entry_finish_time && entry_finish_time < default_finish_time
        conflict_found = true
      end
    end
    conflict_found
  end

  def start_time_modifier(record)
    Time.new(record.entry_date.strftime('%Y'),
             record.entry_date.strftime('%m'),
             record.entry_date.strftime('%d'),
             record.start_time.strftime('%H'),
             record.start_time.strftime('%M'),
             record.start_time.strftime('%S'))
  end

  def finish_time_modifier(record)
    Time.new(record.entry_date.strftime('%Y'),
             record.entry_date.strftime('%m'),
             record.entry_date.strftime('%d'),
             record.finish_time.strftime('%H'),
             record.finish_time.strftime('%M'),
             record.finish_time.strftime('%S'))
  end

end
