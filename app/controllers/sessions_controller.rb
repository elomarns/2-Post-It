class SessionsController < ApplicationController
  before_filter :login_required, :only => :destroy
  
  def new
  end

  def create
    logout_keeping_session!
    
    user = User.authenticate(params[:login], params[:password])
    
    if user
      self.current_user = user

      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag

      flash[:notice] = "Hello, #{user.login}!"

      redirect_back_or_default home_path
    else
      note_failed_signin

      @login       = params[:login]
      @remember_me = params[:remember_me]
      
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!

    flash[:notice] = "It's sad to me say it, but you have been logged out. :("

    redirect_back_or_default root_path
  end

  protected
  def note_failed_signin
    flash[:error] = "Your login and/or password is wrong."
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}."
  end
end