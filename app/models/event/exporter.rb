# coding: utf-8

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

module EventUtils
  class Exporter
    
    def self.to_xls(events)
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8'
      workbook = Spreadsheet::Workbook.new
      worksheet = workbook.create_worksheet :name => "Imputaciones"
      worksheet.row(0).concat %w{Mes Día Proyecto Versión Tarea Descripcion Horas}
      row = 1
      first_day = events.map(&:start_at).min.to_date
      last_day  = events.map(&:end_at).max.to_date
      
      (first_day..last_day).to_a.each do |current_date|
        events_for_current_date = events.find_all do |e|
          interval = e.start_at.to_date..e.end_at.to_date
          interval.include?(current_date)
        end
        breakdown = {}
        events_for_current_date.each do |event|
          breakdown[event.time_tracker] ||= 0
          start_at = [event.start_at, current_date.to_time].max
          end_at   = [event.end_at, current_date.next.to_time].min
          breakdown[event.time_tracker] += event.user.schedule.working_hours_between(start_at, end_at)
        end
        breakdown.each_pair do |t, real_hours|
          a = t.activity
          i = t.issue
          p = i.project
          v = i.fixed_version.name rescue "(sin version)"
          real_hours = (real_hours * 10**2).round.to_f / 10**2
          next if real_hours == 0
          worksheet.row(row).concat [current_date.month, current_date.day, p.name, v, a.name, "#{i.id} #{i.subject}", real_hours ]
          row += 1        
        end
      end
            
      result = StringIO.new
      workbook.write result
      result.string
    end  
    
  end
end