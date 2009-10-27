require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

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
    assert_redirected_to "/"
  end

end