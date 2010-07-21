module TimeTrackersHelper
  def form_to_time_trackers(action, issue, options = {})
    form_options = { :method => :put, :style => 'float:left;' }
    form_tag time_trackers_path + "/#{issue.id}", form_options do
      concat(submit_tag action, options)
    end
  end
end
