class UseCasesController < ApplicationController
  def index
  end
  
  def edit
    @use_case = UseCase.find(params[:id])
  end
  
  def update
    @use_case = UseCase.find(params[:id])
    @use_case.update_attributes(params[:use_case])
    unless @use_case.errors.empty?
      flash.now[:error] = @use_case.errors.on_base
    end
    render :action => 'edit'
  end
end
