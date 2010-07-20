# coding: utf-8
module EventUtils
  class Exporter
    
    def self.to_xls(events)
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8'
      workbook = Spreadsheet::Workbook.new
      worksheet = workbook.create_worksheet :name => "Imputaciones"
      worksheet.row(0).concat %w{Mes Día Proyecto Versión Tarea Descripcion Horas}
      row = 1
      events_per_day = events.group_by { |e| e.start_at.day }
      events_per_day.sort.each do |day, events_for_given_day|
        events_for_given_day.each do |e|
          t = e.time_tracker
          a = t.activity
          i = t.issue
          p = i.project
          v = i.fixed_version.name rescue "(sin version)"
          worksheet.row(row).concat [e.start_at.month, e.start_at.day, p.name, v, a.name, i.subject, e.real_hours ]
          row += 1        
        end
      end
      
      result = StringIO.new
      workbook.write result
      result.string
    end  
    
  end
end