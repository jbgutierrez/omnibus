# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  class Redmine < ActiveRecord::Base; end
  ISSUES_URL = APP_CONFIG['redmine_url'] + '/issues/show/%s'

  def link_to_redmine(issue, name="#{issue.id} - #{issue.subject}")
    link_to truncate(name), ISSUES_URL % issue.id, :target => "_blank", :title => name
  end
  
  def nl2br(s)
    s.gsub(/\n/, '<br/>')
  end
  
  def hours_in_words(hours, hide_minutes=false)
    hours = 0 if hours < 0
    distance_in_hours   = hours.floor
    distance_in_minutes = ((hours - distance_in_hours) * 60).floor
    
    tokens = []
    
    tokens << pluralize(distance_in_hours, 'hora') if distance_in_hours > 0
    tokens << pluralize(distance_in_minutes, 'minuto') unless hide_minutes && distance_in_minutes == 0
    tokens.join(' y ')
  end

end
