require 'test_helper'

class TimesheetEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timesheet_entry = timesheet_entries(:one)
  end

  test "should get index" do
    get timesheet_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_timesheet_entry_url
    assert_response :success
  end

  test "should create timesheet_entry" do
    assert_difference('TimesheetEntry.count') do
      post timesheet_entries_url, params: { timesheet_entry: { entry_date: @timesheet_entry.entry_date, finish_time: @timesheet_entry.finish_time, start_time: @timesheet_entry.start_time, task_name: @timesheet_entry.task_name } }
    end

    assert_redirected_to timesheet_entry_url(TimesheetEntry.last)
  end

  test "should show timesheet_entry" do
    get timesheet_entry_url(@timesheet_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_timesheet_entry_url(@timesheet_entry)
    assert_response :success
  end

  test "should update timesheet_entry" do
    patch timesheet_entry_url(@timesheet_entry), params: { timesheet_entry: { entry_date: @timesheet_entry.entry_date, finish_time: @timesheet_entry.finish_time, start_time: @timesheet_entry.start_time, task_name: @timesheet_entry.task_name } }
    assert_redirected_to timesheet_entry_url(@timesheet_entry)
  end

  test "should destroy timesheet_entry" do
    assert_difference('TimesheetEntry.count', -1) do
      delete timesheet_entry_url(@timesheet_entry)
    end

    assert_redirected_to timesheet_entries_url
  end
end
