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
        Event.populate 1..2 do |e|          
          activities.shuffle!
          time_tracker      = create_or_find_time_tracker(issue, activities.first)
          
          e.start_at        = event_date
          e.end_at          = (event_date + 0.5.days)..(event_date + 2.days)
          event_date        = e.end_at
          e.user_id         = user.id
          e.time_tracker_id = time_tracker.id
        end
      end
    end    
  end
end

def select(issues)
  issues.shuffle!
  issues.first
end

def create_or_find_time_tracker(issue, activity)
  time_tracker          = TimeTracker.new
  time_tracker.issue    = issue
  time_tracker.activity = activity
  time_tracker.save  
  time_tracker
end