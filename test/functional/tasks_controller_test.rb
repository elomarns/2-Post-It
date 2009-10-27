require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  test "should show tasks index page" do
    get :index

    assert_not_nil assigns(:tasks)
    assert_equal Task.all, assigns(:tasks)

    assert_not_nil assigns(:task)
    assert assigns(:task).new_record?
    assert_equal "New Task", assigns(:task).description

    assert_template "index"
    assert_response :success
  end

  test "should show new task form" do
    get :index
    
    assert_select "form#new_task", :count => 1
    assert_select "form#new_task p", :count => 1
    assert_select "form#new_task textarea", :count => 1
  end

  test "should not create task without description through new task form" do
    assert_no_difference "Task.count" do
      post :create, :task => { :description => nil }
    end
  end
  
  test "should not create task with a description bigger than 90 characters through new task form" do
    assert_no_difference "Task.count" do
      post :create, :task => { 
        :description => "Create another website that make me rich, since this one won't give me any money. How about a new video sharing website ? NOT!" }
    end
  end

  test "should create a valid task through new task form" do
    assert_difference 'Task.count' do
      post :create, :task => { :description => "Deploy 2 Post It on Dreamhost VPS." }
    end
  end

  test "should mark existent task as done" do
    put :update, :id => tasks(:study_ajax).to_param, :task => { :done => true }
    
    assert Task.find(tasks(:study_ajax).to_param).done
  end

end
