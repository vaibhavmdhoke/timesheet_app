class DollarCalculator

  def before_save(record)
    record.amount = dollar_value_calculation(record)
  end

  def dollar_value_calculation(record)
    entry_date = record.entry_date
    day = entry_date.strftime('%A').downcase
    amount = 0.0
    case day
    when 'friday', 'monday', 'wednesday'
      amount = calculate_amount_per_entry(record, 22.0, 33.0, Time.new(entry_date.strftime("%Y"), entry_date.strftime("%m"), entry_date.strftime("%d"), 07,00), Time.new(entry_date.strftime("%Y"), entry_date.strftime("%m"), entry_date.strftime("%d"), 19,00))
    when 'tuesday', 'thursday'
      amount = calculate_amount_per_entry(record, 25.0, 35.0, Time.new(entry_date.strftime("%Y"), entry_date.strftime("%m"), entry_date.strftime("%d"), 05,00), Time.new(entry_date.strftime("%Y"), entry_date.strftime("%m"), entry_date.strftime("%d"), 17,00))
    else
      ## TODO: Check this calculation
      amount = time_calculator(record.finish_time, record.start_time) * 47.0
    end
    amount
  end

  def calculate_amount_per_entry(record, base_rate, outside_base_rate, lower_limit_time, upper_limit_time)
    default_start_time = start_time_modifier(record)
    default_finish_time = finish_time_modifier(record)
    amount = 0
    if default_start_time.to_i > lower_limit_time.to_i && default_finish_time.to_i < upper_limit_time.to_i
      amount = time_calculator(default_finish_time, default_start_time) * base_rate
    elsif default_start_time.to_i < lower_limit_time.to_i && default_finish_time.to_i < upper_limit_time.to_i
      amount = time_calculator(lower_limit_time, default_start_time) * outside_base_rate
      amount += time_calculator(default_finish_time, lower_limit_time) * base_rate
    elsif default_start_time.to_i > lower_limit_time.to_i && default_finish_time.to_i > upper_limit_time.to_i
      amount = time_calculator(upper_limit_time, default_start_time) * base_rate
      amount += time_calculator(default_finish_time, upper_limit_time) * outside_base_rate
    elsif default_start_time.to_i < lower_limit_time.to_i && default_finish_time.to_i > upper_limit_time.to_i
      amount = time_calculator(lower_limit_time, default_start_time) * outside_base_rate
      amount += time_calculator(upper_limit_time, lower_limit_time) * base_rate
      amount += time_calculator(default_finish_time, upper_limit_time) * outside_base_rate
    end
    amount
  end

  private
  def time_calculator(finish_time, start_time)
    (finish_time.to_f - start_time.to_f) / 3600.0
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
