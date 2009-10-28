require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should show sign up page" do
    get :new
    
    assert_not_nil assigns(:user)
    assert assigns(:user).new_record?

    assert_template "new"
    assert_response :success
  end

  test "should show sign up form" do
    get :new
    assert_select "form", :count => 1
    assert_select "form > p", :count => 4
    assert_select "form > p > label", :count => 3
    assert_select "form > p > input", :count => 4
  end

  test "should not create user without login through sign up form" do
    assert_no_difference "User.count" do
      post :create, :user => { :user => nil, :password => "elomarnsrocks",
        :password_confirmation => "elomarnsrocks"}
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user without password through sign up form" do
    assert_no_difference "User.count" do
      post :create, :user => { :user => "carla_almeida", :password => nil,
        :password_confirmation => "very_weak_password" }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user without password confirmation through sign up form" do
    assert_no_difference "User.count" do
      post :create, :user => { :user => "anothersal", :password => "mybirthday",
        :password_confirmation => nil }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user without password equal to password confirmation through sign up form" do
    assert_no_difference "User.count" do
      post :create, :user => { :user => "ecsavier", :password => "290485",
        :password_confirmation => "29041985" }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should not create user with an existent login through sign up form" do
    assert_no_difference "User.count" do
      post :create, :user => { :user => "maria_jose", :password => "salvador",
        :password_confirmation => "salvador" }
    end

    assert_nil flash[:notice]
    assert_template "new"
  end

  test "should create a valid user through sign up form" do
    assert_difference "User.count" do
      post :create, :user => { :login => "carlos_almeida", :password => "trovaoazul",
        :password_confirmation => "trovaoazul" }
    end
    
    assert_not_nil flash[:notice]
    assert_equal "Welcome, #{assigns(:user).login}.", flash[:notice]
    assert_redirected_to home_path
  end

  test "should redirect unlogged users to login page" do
    get :home

    assert_redirected_to login_path
  end

  test "should show user home page" do
    login_as :daniel_marques

    get :home

    assert_not_nil assigns(:tasks)
    assert_equal users(:daniel_marques).tasks, assigns(:tasks)

    assert_not_nil assigns(:task)
    assert assigns(:task).new_record?
    assert_equal "New Task", assigns(:task).description

    assert_template "home"
    assert_response :success
  end

  test "should show new task form" do
    login_as :aaron

    get :home

    assert_select "form#new_task", :count => 1
    assert_select "form#new_task p", :count => 1
    assert_select "form#new_task textarea", :count => 1
  end


end