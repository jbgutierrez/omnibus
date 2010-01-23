class UseCasesController < InheritedResources::Base
  def index
  end
  
  def edit
    @use_case = UseCase.find(params[:id])
  end
  
  def update
    super do
      unless @use_case.errors.empty?
        flash.now[:error] = @use_case.errors.on_base
      end      
    end
  end
end
