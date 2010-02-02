# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  class Redmine < ActiveRecord::Base; end
  QUERY = <<eol
  SELECT issues.id as issue_id, issues.subject as subject
  FROM issues, custom_values
  WHERE issues.id = custom_values.customized_id and custom_values.custom_field_id = 5 and %s
eol
  ISSUES_URL = APP_CONFIG['redmine_url'] + '/issues/show/%s'

  def issues_for(requirements)
    Redmine.establish_connection :redmine
    rows = Redmine.connection.select_all(QUERY % like_part(requirements))
    rows.map do |values|
      link_to truncate(values['subject'], 40), ISSUES_URL % values['issue_id'], :target => "_blank"
    end
  end
  
  def nl2br(s)
    s.gsub(/\n/, '<br/>')
  end
  
  private
  
  def like_part(requirements)
    likes = requirements.map{|r| "custom_values.value LIKE '%#{r.code}%'"}
    "(" + likes.join(' OR ') +")"
  end

end
