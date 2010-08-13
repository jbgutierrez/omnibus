class UseCasesController < InheritedResources::Base
  cache_sweeper :use_case_sweeper, :only => [ :create, :update, :destroy ]

  def index
    @functional_areas = FunctionalArea.all(:include => { :use_case_diagrams => :use_cases })
  end
  
  def show
    @use_case = UseCase.find(params[:id])
    flash.now[:notice] = "Este caso de uso no está relacionado con ningún requerimiento. Arréglalo cuanto antes para asegurar la #{@template.link_to('trazabilidad', list_requirements_path)}!" if @use_case.requirements.empty?
    show!
  end
end
