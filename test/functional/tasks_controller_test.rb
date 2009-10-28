require 'test_helper'

class TasksControllerTest < ActionController::TestCase

  test "should not create task without description through new task form" do
    login_as :fake_elomarns

    assert_no_difference "Task.count" do
      post :create, :task => { :description => nil }
    end
  end
  
  test "should not create task with a description bigger than 90 characters through new task form" do
    login_as :fake_elomarns

    assert_no_difference "Task.count" do
      post :create, :task => { 
        :description => "Create another website that make me rich, since this one won't give me any money. How about a new video sharing website ? NOT!" }
    end
  end

  test "should create a valid task through new task form" do
    login_as :fake_elomarns

    assert_difference 'Task.count' do
      post :create, :task => { :description => "Deploy 2 Post It on Dreamhost VPS." }
    end

    assert_equal users(:fake_elomarns), assigns(:task).user
  end

  test "should mark existent task as done" do
    login_as :fake_elomarns

    put :update, :id => tasks(:study_ajax).to_param, :task => { :done => true }
    
    assert Task.find(tasks(:study_ajax).to_param).done
  end

end
