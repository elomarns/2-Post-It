require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  # TODO: Test the rendering of layout application.html.erb.
  test "should show layout" do
    get :index

    assert_select "html", :count => 1

    assert_select "head", :count => 1
    assert_select "meta", :count => 4
    assert_select "meta[http-equiv=Content-Type]", :count => 1
    assert_select "meta[name=description]", :count => 1
    assert_select "meta[name=keywords]", :count => 1
    assert_select "meta[name=author]", :count => 1

    assert_select "body", :count => 1
    assert_select "div#header", :count => 1
    assert_select "p#footer", :count => 1
  end

  test "should get website home" do
    get :index

    assert_template "index"
    assert_response :success
  end
  
  # TODO: Test the rendering of entire website index page (not only the sign in form).

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