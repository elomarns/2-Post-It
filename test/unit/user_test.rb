require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper

  test "should require user login" do
    assert_no_difference 'User.count' do
      user_without_login = User.create(:login => nil, :password => "my_password",
        :password_confirmation => "my_password")

      assert !user_without_login.valid?
      assert user_without_login.new_record?
      assert_equal 1, user_without_login.errors.size
      assert user_without_login.errors.on(:login)
      assert_equal "No login, no sign up!", user_without_login.errors.on(:login)
    end
  end

  test "should require user password" do
    assert_no_difference 'User.count' do
      user_without_password = User.create(:login => "elomarns", :password => nil,
        :password_confirmation => "my_other_password")

      assert !user_without_password.valid?
      assert user_without_password.new_record?
      assert_equal 1, user_without_password.errors.size
      assert user_without_password.errors.on(:password)
      assert_equal "Where's your password?", user_without_password.errors.on(:password)
    end
  end

  test "should require user password confirmation" do
    assert_no_difference 'User.count' do
      user_without_password_confirmation = User.create(:login => "xaxa",
        :password => "a_very_weak_password", :password_confirmation => nil)

      assert !user_without_password_confirmation.valid?
      assert user_without_password_confirmation.new_record?
      assert_equal 1, user_without_password_confirmation.errors.size
      assert user_without_password_confirmation.errors.on(:password_confirmation)
      assert_equal "Did someone saw this field's value?",
        user_without_password_confirmation.errors.on(:password_confirmation)
    end
  end

  test "should require a matching password confirmation" do
    assert_no_difference 'User.count' do
      user_with_a_password_confirmation_not_matching = User.create(:login => "bighi",
        :password => "this is a password", :password_confirmation => "nice password")

      assert !user_with_a_password_confirmation_not_matching.valid?
      assert user_with_a_password_confirmation_not_matching.new_record?
      assert_equal 1, user_with_a_password_confirmation_not_matching.errors.size
      assert user_with_a_password_confirmation_not_matching.errors.on(:password)
      assert_equal "Beh! It doesn't match!",
        user_with_a_password_confirmation_not_matching.errors.on(:password)
    end
  end

  test "should require a unique login" do
    assert_no_difference 'User.count' do
      user_with_existent_login = User.create(:login => "nerdaniel",
        :password => "a-really_funny_password", :password_confirmation => "a-really_funny_password")

      assert !user_with_existent_login.valid?
      assert user_with_existent_login.new_record?
      assert_equal 1, user_with_existent_login.errors.size
      assert user_with_existent_login.errors.on(:login)
      assert_equal "Bad news, someone's using this login.",
        user_with_existent_login.errors.on(:login)
    end
  end

  test "should require a unique login without consider case sensitive" do
    assert_no_difference 'User.count' do
      user_with_existent_login = User.create(:login => "douglas_afonso",
        :password => "imaginary_password", :password_confirmation => "imaginary_password")

      assert !user_with_existent_login.valid?
      assert user_with_existent_login.new_record?
      assert_equal 1, user_with_existent_login.errors.size
      assert user_with_existent_login.errors.on(:login)
      assert_equal "Bad news, someone's using this login.",
        user_with_existent_login.errors.on(:login)
    end
  end

  test "should create a valid user" do
    assert_difference "User.count" do
      valid_user = User.create(:login => "vivimlima", :password => "another_borring password",
        :password_confirmation => "another_borring password")

      assert valid_user.valid?
      assert !valid_user.new_record?
      assert_equal 0, valid_user.errors.size
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

end