# coding: utf-8
module RequirementUtils
  class Exporter
    
    def self.to_xls
      require 'spreadsheet'
      Spreadsheet.client_encoding = 'UTF-8'
      workbook = Spreadsheet::Workbook.new
      worksheet = workbook.create_worksheet :name => "Requerimientos"
      worksheet.row(0).concat %w{Código Nombre Descripción Fecha Estado Versión}
      row = 1
      Requirement.all.each do |requirement|
        versions = requirement.versions + [ requirement ]
        versions.each do |version|
          worksheet.row(row).concat [version.code, version.name, version.description, version.date, version.status, version.release_version]
          row += 1
        end
      end
      
      result = StringIO.new
      workbook.write result
      result.string
    end  
  
  end
end
