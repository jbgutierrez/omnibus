class UseCasesController < InheritedResources::Base
  def update
    super do
      unless @use_case.errors.empty?
        flash.now[:error] = @use_case.errors.on_base
      end      
    end
  end
  
  def export_tests
    config = Rails::Configuration.new
    name = config.database_configuration[RAILS_ENV]["database"].upcase
    export = "<H1> Product: #{name} </h1>\n"
    UseCaseDiagram.all.each do |group|
      export << "<h2> Add group: #{group.name} </h2> Lorem ipsum dolor sit amet ...\n"
    end
    UseCase.all.each do |use_case|
      next if use_case.ppee_test.nil?
      @use_case = use_case
      export << render_to_string(:partial => 'testrunner')
    end
    send_data(export, :filename => "export.xml", :type => "text/xml")
  end
end
