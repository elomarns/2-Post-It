class TasksController < ApplicationController
  before_filter :login_required, :only => [ :create, :update ]

  # OPTMIZE: Use RJS template.
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

  # IMPROVE: Use RJS template.
  # PUT /tasks/1
  def update
    @task = Task.find(params[:id])

    render :update do |page|
      page.visual_effect :fade, "task_#{@task.id}" if @task.user == current_user and @task.update_attributes(params[:task])
    end
  end
end