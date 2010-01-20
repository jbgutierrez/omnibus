namespace :db do
  desc "Importa los datos del modelo de rsa"
  task :import, [:input_file] => [:drop, :migrate] do |t, args|
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

end