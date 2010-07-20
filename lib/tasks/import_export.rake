# coding: utf-8
namespace :ppee do
  desc "Importa los datos del modelo de rsa"
  task :import_use_cases_from_xml, [:input_file] => :environment do |t, args|
    require 'nokogiri'

    original_contents = File.read(args[:input_file])
    document = Nokogiri::XML(original_contents)

    packages = document.xpath('//uml:Model/packagedElement')
    packages.each	do |package|
      p = FunctionalArea.create(:name => package['name'])
      subsystems = package.xpath('./packagedElement[@xmi:type="uml:UseCase"]')
      subsystems.each do |subsystem|
        s = p.use_case_diagrams.create(:name => subsystem[:name])
        subsystem.xpath('.//ownedUseCase').each do |usecase|
          s.use_cases.build(:name => usecase[:name]).save(false)
        end
      end
    end
    
  end
  
  desc "Importa los tests desde ficheros de texto"
  task :import_tests, [:folder_path] => :environment do |t, args|
    require 'iconv'
    folder_path = args[:folder_path].chomp('/')
    Dir.entries(folder_path).grep(/test$/).each do |file_name|
      if (use_case = UseCase.find_by_name(file_name.chomp('.test')))
        test = File.read(folder_path + '/' + file_name)
        test = Iconv.conv('utf-8', 'iso-8859-1', test)
        use_case.test_cases = test
        use_case.save! rescue puts "Error: #{file_name}"
      else
        puts "No encuentro el caso de uso #{file_name}"
      end
    end
  end

  desc "Importa los datos desde la estructura de ficheros"
  task :import_use_cases, [:folder_path] => :environment do |t, args|
    folder_path = args[:folder_path].chomp('/')
    subdirectories = lambda { |folder| Dir.entries(folder).reject{ |f| !File.directory?("#{folder}/#{f}") or f.start_with?('.') } }
    packages = subdirectories.call(folder_path)
    packages.each	do |package|
      p = FunctionalArea.create(:name => package)
      subsystems = subdirectories.call("#{folder_path}/#{package}")
      subsystems.each do |subsystem|
        s = p.use_case_diagrams.create(:name => subsystem)
        usecases = Dir.entries("#{folder_path}/#{package}/#{subsystem}").reject{ |f| File.directory?(f) or !f.end_with?('.doc') }
        usecases.each do |usecase|          
          s.use_cases.build(:name => usecase.chomp('.doc')).save(false)
        end
      end
    end
  end
  
  desc "Importa las relaciones entre casos de uso y requerimientos a partir de la RQ005.xml"
  task :import_relations, [:input_file] => :environment do |t, args|
    require 'time'
    require 'nokogiri'
    original_contents = File.read(args[:input_file])
    document = Nokogiri::XML(original_contents.gsub('&#13;&#13;', "\n")) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end
    
    rows = document.root.xpath("//ss:Worksheet[@ss:Name='Requerimientos-CU']/ss:Table/ss:Row")
    rows.shift
    rows.each do |row|
      cells = row.xpath('ss:Cell').map(&:text)
      requirement = cells[0].squeeze(" ")
      use_case = cells[1].squeeze(" ")
      r = Requirement.find_by_name(requirement)
      u = UseCase.find_by_name(use_case)
      if r and u
        r.use_cases << u unless r.use_cases.include?(u)
      else
        puts "#{requirement} - #{use_case}"
      end
    end
    
  end
  
  desc "Importa los requerimientos a partir de la RQ005.xml"
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
        when "Original"; :original
        when "Aceptado"; :original
        when "Detallado"; :detallado
        when "En curso"; :en_curso
        when "En pruebas"; :en_pruebas
        when "Finalizado"; :finalizado
        when "Anulado"; :anulado
        when "Anulado*:\rSe determina que no tiene sentido\r"; :anulado
        when "Diferido"; :modificado
        when "Implantado"; :implantado
        when "Alterado"; :alterado
        when "Modificado"; :modificado
      end
    end
    
    rows = document.root.xpath("//ss:Worksheet[@ss:Name='Funcionales']/ss:Table/ss:Row")
    rows.shift
    requirements = rows.map do |row|
      cells = row.xpath('ss:Cell').map(&:text)
      cells[3] ||= '2011-01-01T00:00:00Z'
      cells[4] ||= 'Original'
      params = { :code => cells[0], :name => cells[1], :description => cells[2].gsub("...", 'El sistema permitirá'), :date => Time.xmlschema(cells[3]), :status => translate_status.call(cells[4]).to_s, :release_version => cells[5]  }
      requirement = Requirement.find_by_code(params[:code]) || Requirement.new
      requirement.attributes = params
      requirement.save!
    end
        
  end

end
