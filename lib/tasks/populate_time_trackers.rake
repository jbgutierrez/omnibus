class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(Kernel.rand(n)) }
    self
  end
end

namespace :db do
  desc "Puebla las imputaciones reales de peticiones estimadas de redmine"
  task :populate => :environment do
    require 'populator'

    activities  = Activity.all
    users       = User.all    
    issues      = Issue.all
    total_time  = issues.map(&:estimated_hours).sum
    total_users = users.size
    total_days  = total_time / total_users
    
    users.each do |user|
      event_date = total_days.days.ago
      while(event_date < DateTime.now) do
        issue        = select(issues)
        activities.shuffle!
        time_tracker      = create_or_find_time_tracker(issue, activities.first)
        event = Event.populate 1 do |e|          
          e.start_at        = event_date
          e.end_at          = (event_date + 0.1.days)..(event_date + 1.2.days)
          event_date        = e.end_at
          e.user_id         = user.id
          e.time_tracker_id = time_tracker.id
        end
        time_tracker.events << event.values
      end
    end    
  end
end

def select(issues)
  # issues.shuffle!
  issues.find{|i| i.estimated_hours * 0.9 >= i.real_hours } || exit
end

def create_or_find_time_tracker(issue, activity)
  time_tracker          = TimeTracker.find_by_issue_id_and_activity_id(issue, activity) || issue.time_trackers.build
  time_tracker.issue    = issue
  time_tracker.activity = activity
  time_tracker.save
  
  issue.time_trackers << time_tracker
  time_tracker
end