# coding: utf-8
class RequirementsSpreadsheet < Struct.new(:filename, :url, :created_at)
  
  def self.refresh(filename = DEFAULT_FILENAME)
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
    workbook.write RAILS_ROOT + '/public' + REPORTS_PATH + filename
  end  
  
  def self.spreadsheet_info_for(filename = DEFAULT_FILENAME)
    full_path = RAILS_ROOT + '/public' + REPORTS_PATH + filename
    new(filename, REPORTS_PATH + filename, File.mtime(full_path))
  end
  
  private

  DEFAULT_FILENAME = 'project.xls'
  REPORTS_PATH = '/reports/'

end
