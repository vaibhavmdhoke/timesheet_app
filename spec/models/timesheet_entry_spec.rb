require 'rails_helper'
require 'pry'
RSpec.describe TimesheetEntry, type: :model do
  # pending 'add some examples to (or delete) #{__FILE__}'

  context 'Validations' do
    it { should validate_presence_of(:entry_date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:finish_time) }
    it 'should not be able to create duplicate records as they are conflicting' do
      existing_entry = FactoryGirl.build(:timesheet_entry) ## 22 april monday entry
      expect(existing_entry).not_to be_valid
    end
  end

  describe 'Check For Conflicts' do
    it 'should check if new_entry"s start_time falls in conflict' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-22', start_time: '16:00', finish_time: '20:00')
      expect(new_entry).not_to be_valid
    end

    it 'should check if new_entry"s finish_time falls in conflict' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-22', start_time: '05:00', finish_time: '14:00' )
      expect(new_entry).not_to be_valid
    end

    it 'should check if new_entry"s finish_time & start_time falls in conflict' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-22', start_time: '13:00', finish_time: '14:00' )
      expect(new_entry).not_to be_valid
    end


    it 'should check if old"s finish_time & start_time falls in conflict' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-22', start_time: '01:00', finish_time: '19:00' )
      expect(new_entry).not_to be_valid
    end

    it 'should check if old"s finish_time falls in conflict' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-22', start_time: '09:00', finish_time: '10:00:28' )
      expect(new_entry).not_to be_valid
    end

    it 'should check if old"s start_time falls in conflict' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-22', start_time: '17:00:28', finish_time: '19:00:30' )
      expect(new_entry).not_to be_valid
    end
  end

  describe "Check For Calculations" do
    it 'Monday Rate' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-29', start_time: '10:00', finish_time: '17:00' )
      new_entry.save
      expect(new_entry.amount).equal?(154.0)
    end

    it 'Tuesday Rate' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-16', start_time: '12:00', finish_time: '20:15' )
      new_entry.save
      expect(new_entry.amount).equal?(238.75)
    end

    it 'Wednesday Rate' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-17', start_time: '04:00', finish_time: '21:30' )
      new_entry.save
      expect(new_entry.amount).equal?(445.5)
    end

    it 'Weekend Rate' do
      new_entry = TimesheetEntry.new(entry_date: '2019-04-20', start_time: '15:00', finish_time: '20:00' )
      new_entry.save
      expect(new_entry.amount).equal?(211.5)
    end
  end

end
