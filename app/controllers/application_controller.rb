# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include CurrentUserModule
  before_filter :authenticate
  filter_parameter_logging :password
  helper_method :current_user

  private

  def authenticate
    unless development?
      authenticate_or_request_with_http_basic do |username, password|
        @user ||= User.try_to_login(username, password)
      end
    else
      @user ||= User.find(1)
    end
    session[:user]    = @user.id rescue nil
    self.current_user = @user
  end
  
  def development?
    ENV["RAILS_ENV"] == "development"
  end
  
end
