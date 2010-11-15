# coding: utf-8
require 'haml'
module UseCaseUtils
  class Exporter
    
    def self.to_xml
      path     = "#{RAILS_ROOT}/app/views/use_cases/_testlink.html.haml"
      template = File.read(path)
      engine   = Haml::Engine.new(template)

      config = Rails::Configuration.new
      name = config.database_configuration[RAILS_ENV]["database"].upcase
      export = "<?xml version='1.0' enconding='utf-8'>"
      export << "<testsuite name=''>"
      FunctionalArea.all.each do |area|
        export << "<testsuite name='#{area.name}'>"
        area.use_case_diagrams.all.each do |group|
          export << "<testsuite name='#{group.name}'>"
          group.use_cases.each do |use_case|
            next if use_case.ppee_test.nil?
            @use_case = use_case
            export << engine.render(binding)
          end
          export << "</testsuite>"
        end
        export << "</testsuite>"
      end
      export << "</testsuite>"
    end  
  
  end
end
