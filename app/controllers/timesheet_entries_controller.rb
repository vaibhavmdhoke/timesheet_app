class TimesheetEntriesController < ApplicationController
  before_action :set_timesheet_entry, only: [:show, :edit, :update, :destroy]

  # GET /timesheet_entries
  # GET /timesheet_entries.json
  def index
    @timesheet_entries = TimesheetEntry.all
  end

  # GET /timesheet_entries/1
  # GET /timesheet_entries/1.json
  def show
  end

  # GET /timesheet_entries/new
  def new
    @timesheet_entry = TimesheetEntry.new
  end

  # GET /timesheet_entries/1/edit
  def edit
  end

  # POST /timesheet_entries
  # POST /timesheet_entries.json
  def create
    @timesheet_entry = TimesheetEntry.new(timesheet_entry_params)

    respond_to do |format|
      if @timesheet_entry.save
        format.html { redirect_to @timesheet_entry, notice: 'Timesheet entry was successfully created.' }
        format.json { render :show, status: :created, location: @timesheet_entry }
      else
        format.html { render :new }
        format.json { render json: @timesheet_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timesheet_entries/1
  # PATCH/PUT /timesheet_entries/1.json
  def update
    respond_to do |format|
      if @timesheet_entry.update(timesheet_entry_params)
        format.html { redirect_to @timesheet_entry, notice: 'Timesheet entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @timesheet_entry }
      else
        format.html { render :edit }
        format.json { render json: @timesheet_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timesheet_entries/1
  # DELETE /timesheet_entries/1.json
  def destroy
    @timesheet_entry.destroy
    respond_to do |format|
      format.html { redirect_to timesheet_entries_url, notice: 'Timesheet entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timesheet_entry
      @timesheet_entry = TimesheetEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timesheet_entry_params
      params.require(:timesheet_entry).permit(:task_name, :entry_date, :start_time, :finish_time)
    end
end
