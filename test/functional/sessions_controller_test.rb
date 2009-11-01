require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  fixtures :users

  test "should get sign in page" do
    get :new

    assert_template "new"
    assert_response :success
  end
  
  # TODO: Test the rendering of entire sign in page (not only sign in form).

  test "should show sign in page" do
    get :new

    assert_select "div#content", :count => 1
    assert_select "h1", :count => 1
  end

  test "should show sign in form" do
    get :new

    assert_select "form", :count => 1
    assert_select "form > p", :count => 4
    assert_select "form > p > label", :count => 3
    assert_select "form > p > input", :count => 4
    assert_select "form > p > input[type=text]", :count => 1
    assert_select "form > p > input[type=password]", :count => 1
    assert_select "form > p > input[type=submit]", :count => 1
    assert_select "form > p > input[type=checkbox]", :count => 1
  end

  test "should not sign in an inexistent user" do
    post :create, :login => "mr_hank", :password => "howdy_ho"

    assert_nil session[:user_id]
    assert_equal "Your login and/or password is wrong.", flash[:error]
    assert_response :success
  end

  test "should not sign in an user with wrong password" do
    post :create, :login => "aaron", :password => "elephant"

    assert_nil session[:user_id]
    assert_equal "Your login and/or password is wrong.", flash[:error]
    assert_response :success
  end

  test "should sign in user" do
    post :create, :login => "technoweenie", :password => "rickolson"

    assert_equal users(:technoweenie).id, session[:user_id]
    assert_equal "Hello, #{users(:technoweenie).login}!", flash[:notice]
    assert_response :redirect
  end

  test "should remember me" do
    @request.cookies["auth_token"] = nil

    post :create, :login => "aaron", :password => "monkey", :remember_me => "1"
    
    assert_not_nil @response.cookies["auth_token"]
  end

  test "should not remember me" do
    @request.cookies["auth_token"] = nil

    post :create, :login => "nerdaniel", :password => "alice", :remember_me => "0"

    assert @response.cookies["auth_token"].blank?
  end

  test "should login with cookie" do
    users(:fake_elomarns).remember_me

    @request.cookies["auth_token"] = cookie_for(:fake_elomarns)

    get :new
    
    assert @controller.send(:logged_in?)
  end

  test "should fail expired cookie login" do
    users(:elomar).remember_me

    users(:elomar).update_attribute :remember_token_expires_at, 5.minutes.ago
    
    @request.cookies["auth_token"] = cookie_for(:elomar)

    get :new
    
    assert !@controller.send(:logged_in?)
  end

  test "should fail cookie login" do
    users(:edgard).remember_me
    
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    
    get :new
    
    assert !@controller.send(:logged_in?)
  end

  test "should not logout if not logged in" do
    get :destroy

    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should logout" do
    login_as :maria_jose

    get :destroy
    
    assert_nil session[:user_id]
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should delete token on logout" do
    login_as :mgurgel

    get :destroy

    assert @response.cookies["auth_token"].blank?
  end

  private
  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token users(user).remember_token
  end
end