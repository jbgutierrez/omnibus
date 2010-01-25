class RequirementsController < InheritedResources::Base
  def index
    @search = Requirement.search params[:search]
    @requirements = @search.paginate :page => params[:page], :order => 'created_at DESC'
  end
  
  def list
    unless params[:use_case_id].nil?
      @use_case = UseCase.find(params[:use_case_id])
      @requirement = Requirement.find(params[:requirement_id])
      case params[:list_action]
        when 'add':
          @use_case.requirements << @requirement unless @use_case.requirements.include?(@requirement)
        when 'destroy'
          @use_case.requirements.delete(@requirement) if @use_case.requirements.include?(@requirement)
      end
    end
  end
end
