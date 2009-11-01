require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get sign up page" do
    get :new
    
    assert_not_nil assigns(:user)
    assert assigns(:user).new_record?

    assert_template "new"
    assert_response :success
  end

  # TODO: Test the rendering of entire sign up page (not only sign up form).

  test "should show sign up form" do
    get :new

    assert_select "form", :count => 1
    assert_select "form > p", :count => 4
    assert_select "form > p > label", :count => 3
    assert_select "form > p > input", :count => 4
    assert_select "form > p > input[type=text]", :count => 1
    assert_select "form > p > input[type=password]", :count => 2
    assert_select "form > p > input[type=submit]", :count => 1
  end

  test "should not create user without login" do
    assert_no_difference "User.count" do
      post :create, :user => { :login => nil, :password => "nevermind",
        :password_confirmation => "nevermind" }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user without password" do
    assert_no_difference "User.count" do
      post :create, :user => { :login => "carla_almeida", :password => nil,
        :password_confirmation => "221283" }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user without password confirmation" do
    assert_no_difference "User.count" do
      post :create, :user => { :login => "anothersal", :password => "greenthunder",
        :password_confirmation => nil }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user without a matching password confirmation" do
    assert_no_difference "User.count" do
      post :create, :user => { :login => "ecsavier", :password => "moremimimi",
        :password_confirmation => "evenmoremimimi" }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user with an existent login" do
    assert_no_difference "User.count" do
      post :create, :user => { :login => "maria_jose", :password => "bahia",
        :password_confirmation => "bahia" }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should create a valid user" do
    assert_difference "User.count" do
      post :create, :user => { :login => "carlos_almeida", :password => "anothersal",
        :password_confirmation => "anothersal" }
    end
    
    assert_equal "Welcome, #{assigns(:user).login}.", flash[:notice]
    assert_redirected_to home_path
  end

  test "should redirect unlogged users to sign in page" do
    get :home

    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should get user home page" do
    login_as :nerdaniel

    get :home

    assert_equal users(:nerdaniel).tasks, assigns(:tasks)

    assert assigns(:task).new_record?
    assert_equal "New Task", assigns(:task).description

    assert_template "home"
    assert_response :success
  end

  # TODO: Test the rendering of entire user home page (not only new task form).

  test "should show new task form" do
    login_as :aaron

    get :home

    assert_select "form#new_task", :count => 1
    assert_select "form#new_task > p", :count => 1
    assert_select "form#new_task > p > textarea", :count => 1
  end
end