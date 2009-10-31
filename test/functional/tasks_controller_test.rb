require 'test_helper'

class TasksControllerTest < ActionController::TestCase

  test "should not create task without description" do
    login_as :technoweenie

    assert_no_difference "Task.count" do
      post :create, :task => { :description => nil }
    end
  end
  
  test "should not create task with a description bigger than 90 characters" do
    login_as :elomar

    assert_no_difference "Task.count" do
      post :create, :task => { 
        :description => "Create another website that make me rich, since this one won't give me any money. How about a new video sharing website ? NOT!" }
    end
  end

  test "should create task" do
    login_as :leonardo_bighi

    assert_difference "Task.count" do
      post :create, :task => { :description => "Watch Twilight again." }
    end

    assert_equal users(:leonardo_bighi), assigns(:task).user
  end

  test "should not mark task as done if the user is not the owner" do
    login_as :maria_jose

    put :update, :id => tasks(:study_ajax).to_param, :task => { :done => true }

    assert !Task.find(tasks(:study_ajax).id).done
  end


  test "should mark task as done" do
    login_as :mgurgel

    put :update, :id => tasks(:stop_listening_radiohead).to_param, :task => { :done => true }
    
    assert Task.find(tasks(:stop_listening_radiohead).id).done
  end
end