class TimesheetEntry < ApplicationRecord
  validates :start_time, :finish_time, :entry_date, presence: true
  validates_with TimesheetValidator
  before_save DollarCalculator.new

end
