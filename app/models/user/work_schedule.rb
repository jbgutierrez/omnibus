require "time"
require "date"

class Date
  def to_time
    Time.local(year, month, day)
  end
end

class Time
  def to_date
    Date.new(year, month, day)
  end
end

class WorkSchedule

  def initialize(*hours)
    @schedule = { :default => hours }
  end

  def update(day, *hours)
    key = day.kind_of?(Symbol) ? Date.parse(day.to_s).wday : Date.parse(day)
    @schedule[key] = *hours
  end

  def set_holidays_on(*days)
    days.each{ |day| update(day, "0:00", "0:00") }
  end

  def working_hours_between(start_at, end_at)
    start_at = start_at.kind_of?(String) ? Time.parse(start_at) : start_at
    end_at   = end_at.kind_of?(String) ? Time.parse(end_at) : end_at
    WorkingHoursAlgorithm.new(@schedule, start_at, end_at).calculate
  end

  class WorkingHoursAlgorithm
    def initialize(*args)
      @schedule, @current_time, @stop_time = *args
    end

    def calculate
      result = 0
      result += compute_working_hours while days_left?
      result / 3600.0
    end

    private

    def compute_working_hours
      stop_time  = [ @current_time.to_date.next.to_time, @stop_time, stop_time_allowed ].min
      start_time = [ @current_time, start_time_allowed ].max
      @current_time = @current_time.to_date.next.to_time 
      diference = stop_time - start_time
      diference < 0 ? 0 : diference
    end

    def days_left?
      @current_time.to_date <= @stop_time.to_date
    end

    def start_time_allowed
      Time.parse(current_working_hours.first, @current_time.to_date)
    end

    def stop_time_allowed
      Time.parse(current_working_hours.last, @current_time.to_date)
    end

    def current_working_hours
      @schedule[@current_time.to_date] || @schedule[@current_time.wday] || @schedule[:default]     
    end

  end
end
