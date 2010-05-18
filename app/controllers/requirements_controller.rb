class RequirementsController < InheritedResources::Base
  def index
    @search       = Requirement.search params[:search]
    @requirements = @search.paginate :page => params[:page], :per_page => 15, :order => 'created_at DESC'
    hash          = @search.count(:group => 'status')
    data          = hash.values.inspect
    labels        = hash.keys.map{ |k| "#{k.humanize} (#{hash[k]})"}.inspect
    @chart_data =<<eol
{
  data        : #{data},
  axis_labels : #{labels},
  size        : '400x250',
  type        : 'p',
  bg          : '000'
}
eol
  end
  
  def list
    unless params[:use_case_id].nil?
      @use_case = UseCase.find(params[:use_case_id])
      @requirement = Requirement.find(params[:requirement_id])
      case params[:list_action]
        when 'add';
          @use_case.requirements << @requirement unless @use_case.requirements.include?(@requirement)
        when 'destroy';
          @use_case.requirements.delete(@requirement) if @use_case.requirements.include?(@requirement)
      end
    end
  end
  
  def refresh_report
    RequirementsSpreadsheet.send_later(:refresh)
    flash[:notice] = "Se está regenerando el fichero excel."
    redirect_to requirements_url
  end
  
  def edit_multiple
    @search = Requirement.search params[:search]
    @requirements = @search.all
    if @requirements.empty?
      flash[:notice] = "No hay nada que editar!"
      redirect_to requirements_path
    else
      @requirement = Requirement.new
      versions = @requirements.map(&:release_version).uniq
      @requirement.release_version = versions.first unless versions.size > 1
      status = @requirements.map(&:status).uniq
      @requirement.status = status.size > 1 ? nil : status.first
      date = @requirements.map(&:date).uniq
      @requirement.date = date.first unless date.size > 1
    end
  end
  
  def update_multiple
    @requirements = Requirement.find(params[:requirement_ids])
    @requirements.each do |requirement|
      requirement.update_attributes!(params[:requirement].reject {|k,v| v.blank? })
    end
    flash[:success] = "La operación se realizó satisfactoriamente"
    redirect_to requirements_path
  end
end
