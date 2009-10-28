class TasksController < ApplicationController
  before_filter :login_required, :only => [ :create, :update ]

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  def create
    @task = current_user.tasks.new(params[:task])

    render :update do |page|
      if @task.save
        page.insert_html :bottom, "tasks", :partial =>  @task
        page.draggable "task_#{@task.id}"
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    render :update do |page|
      page.visual_effect :fade, "task_#{@task.id}" if @task.update_attributes(params[:task])
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
end