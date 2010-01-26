class UseCasesController < InheritedResources::Base
  def update
    super do
      unless @use_case.errors.empty?
        flash.now[:error] = @use_case.errors.on_base
      end      
    end
  end
end
