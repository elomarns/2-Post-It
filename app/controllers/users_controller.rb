class UsersController < ApplicationController
  include AuthenticatedSystem

  def new
    @user = User.new

    respond_to do |format|
      format.html
    end
  end

  def create
    logout_keeping_session!

    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        self.current_user = @user

        flash[:notice] = "Welcome, #{@user.login}."

        format.html { redirect_back_or_default('/') }
      else
        format.html { render :action => "new" }
      end
    end
  end
end