class UsersController < ApplicationController
  before_filter :login_required, :only => :home

  # GET /users/new
  # GET /signup
  def new
    @user = User.new

    respond_to do |format|
      format.html
    end
  end

  # POST /users
  def create
    logout_keeping_session!

    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        self.current_user = @user

        flash[:notice] = "Welcome, #{@user.login}."

        format.html { redirect_back_or_default home_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # GET /home
  def home
    @tasks = current_user.tasks.find_all_by_done(false)
    @task = Task.new(:description => "New Task")

    respond_to do |format|
      format.html
    end
  end
end