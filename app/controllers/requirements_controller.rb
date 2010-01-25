class RequirementsController < InheritedResources::Base
  def index
    @search = Requirement.search params[:search]
    @requirements = @search.paginate :page => params[:page], :order => 'created_at DESC'
  end
end
