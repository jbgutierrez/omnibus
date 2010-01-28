namespace :db do
  desc "Importa los datos de la RQ005.xml"
  task :import_requirements, [:input_file] => :environment do |t, args|
    require 'time'
    require 'nokogiri'

    Requirement.delete_all
    
    original_contents = File.read(args[:input_file])
    document = Nokogiri::XML(original_contents.gsub('&#13;&#13;', "\n")) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end
    
    translate_status = lambda do |str|
      case str
        when "Original": :original
        when "Aceptado": :original
        when "Detallado": :detallado
        when "En curso": :en_curso
        when "En pruebas": :en_pruebas
        when "Finalizado": :finalizado
        when "Anulado": :anulado
        when "Anulado*:\rSe determina que no tiene sentido\r": :anulado
        when "Diferido": :modificado
      end
    end
    
    rows = document.root.xpath("//ss:Worksheet[@ss:Name='Funcionales']/ss:Table/ss:Row")
    rows.shift
    requirements = rows.map do |row|
      cells = row.xpath('ss:Cell').map(&:text)
      cells[3] ||= '2011-01-01T00:00:00Z'
      cells[6] ||= 'Original'
      params = { :code => cells[0], :name => cells[1], :description => cells[2], :date => Time.xmlschema(cells[3]), :status => translate_status.call(cells[6]).to_s, :release_version => cells[7]  }
      requirement = Requirement.find_by_code(params[:code]) || Requirement.new
      requirement.attributes = params
      requirement.save!
    end
        
  end
  
  task :export_requirements => :environment do |t, args|
    RequirementsSpreadsheet.refresh
  end
end