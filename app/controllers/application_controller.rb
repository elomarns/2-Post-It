# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # TODO: Test password and password confirmation filtering at logs.

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  before_filter :redirect_to_user_home, :only => :index

  private
  def redirect_to_user_home
    redirect_to home_path if current_user
  end
end