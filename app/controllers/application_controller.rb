# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user
  include Userstamp

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password

  def current_user
    session[:user]
  end
  
  before_filter :authenticate

  private

  def authenticate
    unless development?
      authenticate_or_request_with_http_basic do |username, password|
        session[:user] ||= User.try_to_login(username, password)
      end
    else
      session[:user] ||= User.find(1)
    end
  end
  
  def development?
    ENV["RAILS_ENV"] == "development"
  end
  
end
