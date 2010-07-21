require "test/unit"
require File.expand_path(File.dirname(__FILE__) + "/../app/models/user/work_schedule")

class WorkScheduleTest < Test::Unit::TestCase
  def setup
    @schedule = WorkSchedule.new("8:00 AM", "3:00 PM")
  end
  
  def test_within_working_schedule
    assert_equal 5, @schedule.working_hours_between("Jul 20, 2010 8:00 AM", "Jul 20, 2010 1:00 PM")
  end
  
  def test_start_at_opening_time
    assert_equal 5, @schedule.working_hours_between("Jul 20, 2010 7:00 AM", "Jul 20, 2010 1:00 PM")
    assert_equal 5, @schedule.working_hours_between("Jul 19, 2010 4:00 PM", "Jul 20, 2010 1:00 PM")
  end
  
  def test_within_working_schedule_and_spreads_onto_next_day
    assert_equal 5, @schedule.working_hours_between("Jul 19, 2010 2:00 PM", "Jul 20, 2010 0:00 PM")
    assert_equal 19, @schedule.working_hours_between("Jul 19, 2010 2:00 PM", "Jul 22, 2010 0:00 PM")
  end
  
  def test_start_at_opening_time_and_spreads_onto_next_day
    assert_equal 12, @schedule.working_hours_between("Jul 20, 2010 7:00 AM", "Jul 21, 2010 1:00 PM")
    assert_equal 12, @schedule.working_hours_between("Jul 19, 2010 4:00 PM", "Jul 21, 2010 1:00 PM")
  end

  def test_skip_weekends
    @schedule.set_holidays_on :sat, :sun
    assert_equal 5, @schedule.working_hours_between("Jul 18, 2010 4:00 PM", "Jul 19, 2010 1:00 PM")
    assert_equal 12, @schedule.working_hours_between("Jul 18, 2010 4:00 PM", "Jul 20, 2010 1:00 PM")
    assert_equal 12, @schedule.working_hours_between("Jul 17, 2010 4:00 PM", "Jul 20, 2010 1:00 PM")
    assert_equal 12, @schedule.working_hours_between("Jul 16, 2010 4:00 PM", "Jul 20, 2010 1:00 PM")
  end
  
  def test_skip_specific_dates
    @schedule.set_holidays_on "Jul 19, 2010", "Jul 20, 2010"
    assert_equal 0, @schedule.working_hours_between("Jul 18, 2010 4:00 PM", "Jul 20, 2010 1:00 PM")
    assert_equal 0, @schedule.working_hours_between("Jul 19, 2010 4:00 PM", "Jul 20, 2010 1:00 PM")
    assert_equal 5, @schedule.working_hours_between("Jul 18, 2010 4:00 PM", "Jul 21, 2010 1:00 PM")
    assert_equal 5, @schedule.working_hours_between("Jul 19, 2010 4:00 PM", "Jul 21, 2010 1:00 PM")
  end

end
