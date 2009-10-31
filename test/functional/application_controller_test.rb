require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  test "should get website home" do
    get :index

    assert_template "index"
    assert_response :success
  end

  # TODO: test the rendering of entire website index page (not only the sign in form).

  test "should show sign in form" do
    get :index

    assert_select "form", :count => 1
    assert_select "form > p", :count => 4
    assert_select "form > p > input", :count => 4
    assert_select "form > p > input[type=text]", :count => 1
    assert_select "form > p > input[type=password]", :count => 1
    assert_select "form > p > input[type=submit]", :count => 1
    assert_select "form > p > input[type=hidden]", :count => 1
  end

  test "should redirect logged users to home" do
    login_as :edgard

    get :index

    assert_response :redirect
    assert_redirected_to home_path
  end
end