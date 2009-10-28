require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  fixtures :users

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

  test "should sign in an user with correct login and password" do
    post :create, :login => "aaron", :password => "monkey" 

    assert session[:user_id]
    assert_equal "Hello, aaron!", flash[:notice]
    assert_response :redirect
  end

  def test_should_logout
    login_as :quentin
    get :destroy
    assert_nil session[:user_id]
    assert_response :redirect
  end

  def test_should_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "0"
    puts @response.cookies["auth_token"]
    assert @response.cookies["auth_token"].blank?
  end
  
  def test_should_delete_token_on_logout
    login_as :quentin
    get :destroy
    assert @response.cookies["auth_token"].blank?
  end

  def test_should_login_with_cookie
    users(:quentin).remember_me
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:quentin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end