class DepartmentConfig < ActiveRecord::Base
  belongs_to :department

  validates_presence_of :department_id, :printed_message, :reminder_message, :warning_message
  validates_uniqueness_of :department_id
  validates_numericality_of :time_increment, :grace_period, :schedule_start,
                            :schedule_end, :description_min, :reason_min, :warning_weeks

  PAYFORM_PERIOD = [
    ["Weekly",  false],
    ["Monthly", true ]
  ]

  WEEK_DAY_SELECT = [
    [Date::DAYNAMES[0], 0],
    [Date::DAYNAMES[1], 1],
    [Date::DAYNAMES[2], 2],
    [Date::DAYNAMES[3], 3],
    [Date::DAYNAMES[4], 4],
    [Date::DAYNAMES[5], 5],
    [Date::DAYNAMES[6], 6]
  ]

  def calibrate_time
    #allow the schedule for a day to end at, say, 2:00am
    if self
      self.schedule_end += 24*60 if self.schedule_end <= self.schedule_start
      self.save
    end
  end


  # methods for use in the schedule view
  def blocks_per_hour
    60 / self.time_increment
  end

  def blocks_per_day
    ((self.schedule_end - self.schedule_start) / self.time_increment).to_i
  end

  def block_length
    self.time_increment * 60 #seconds
  end

end

