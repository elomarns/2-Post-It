require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "should require login" do
    assert_no_difference "User.count" do
      user_without_login = User.create(:login => nil, :password => "my_password",
        :password_confirmation => "my_password")

      assert !user_without_login.valid?
      assert user_without_login.new_record?
      assert_equal 1, user_without_login.errors.size
      assert_equal "No login, no sign up!", user_without_login.errors.on(:login)
    end
  end

  test "should require password" do
    assert_no_difference "User.count" do
      user_without_password = User.create(:login => "elomarns", :password => nil,
        :password_confirmation => "my_other_password")

      assert !user_without_password.valid?
      assert user_without_password.new_record?
      assert_equal 1, user_without_password.errors.size
      assert_equal "Where's your password?", user_without_password.errors.on(:password)
    end
  end

  test "should require password confirmation" do
    assert_no_difference "User.count" do
      user_without_password_confirmation = User.create(:login => "xaxa",
        :password => "mimimi", :password_confirmation => nil)

      assert !user_without_password_confirmation.valid?
      assert user_without_password_confirmation.new_record?
      assert_equal 1, user_without_password_confirmation.errors.size
      assert_equal "Did someone saw this field's value?",
        user_without_password_confirmation.errors.on(:password_confirmation)
    end
  end

  test "should require a matching password confirmation" do
    assert_no_difference "User.count" do
      user_with_a_password_confirmation_not_matching = User.create(:login => "bighi",
        :password => "ehnois1", :password_confirmation => "ehnois01")

      assert !user_with_a_password_confirmation_not_matching.valid?
      assert user_with_a_password_confirmation_not_matching.new_record?
      assert_equal 1, user_with_a_password_confirmation_not_matching.errors.size
      assert_equal "Beh! It doesn't match!",
        user_with_a_password_confirmation_not_matching.errors.on(:password)
    end
  end

  test "should require unique login" do
    assert_no_difference "User.count" do
      user_with_existent_login = User.create(:login => "nerdaniel",
        :password => "ehiros", :password_confirmation => "ehiros")

      assert !user_with_existent_login.valid?
      assert user_with_existent_login.new_record?
      assert_equal 1, user_with_existent_login.errors.size
      assert_equal "Bad news, someone's using this login.",
        user_with_existent_login.errors.on(:login)
    end
  end

  test "should require unique case insensitive login" do
    assert_no_difference "User.count" do
      user_with_existent_login_without_consider_case_sensitive = User.create(:login => "DOUGLAS_AFONSO",
        :password => "imaginary_password", :password_confirmation => "imaginary_password")

      assert !user_with_existent_login_without_consider_case_sensitive.valid?
      assert user_with_existent_login_without_consider_case_sensitive.new_record?
      assert_equal 1, user_with_existent_login_without_consider_case_sensitive.errors.size
      assert_equal "Bad news, someone's using this login.",
        user_with_existent_login_without_consider_case_sensitive.errors.on(:login)
    end
  end

  test "should create a valid user" do
    assert_difference "User.count" do
      valid_user = User.create(:login => "vivimlima", :password => "passoFUNDO",
        :password_confirmation => "passoFUNDO")

      assert valid_user.valid?
      assert_equal 0, valid_user.errors.size
      assert !valid_user.new_record?
    end
  end

  test "should not authenticate inexistent user" do
    assert_equal nil, User.authenticate("cardoso", "iloveizzy")
  end
  
  test "should not authenticate user with wrong password" do
    assert_equal nil, User.authenticate("nerdaniel", "ehiros")
  end

  test "should authenticate user" do
    assert_equal users(:mgurgel), User.authenticate("mgurgel", "nirvana")
  end

  test "should set remember token" do
    users(:elomar).remember_me
    
    assert_not_nil users(:technoweenie).remember_token
    assert_not_nil users(:technoweenie).remember_token_expires_at
  end

  test "should unset remember token" do
    users(:quentin).forget_me
    
    assert_nil users(:quentin).remember_token
    assert_nil users(:quentin).remember_token_expires_at
  end

  test "should remember me for one week" do
    before = 1.week.from_now.utc

    users(:fake_elomarns).remember_me_for 1.week

    after = 1.week.from_now.utc
    
    assert_not_nil users(:fake_elomarns).remember_token
    assert_not_nil users(:fake_elomarns).remember_token_expires_at
    
    assert users(:fake_elomarns).remember_token_expires_at.between?(before, after)
  end

  test "should remember me until one week" do
    time = 1.week.from_now.utc

    users(:leonardo_bighi).remember_me_until time

    assert_not_nil users(:leonardo_bighi).remember_token
    assert_not_nil users(:leonardo_bighi).remember_token_expires_at

    assert_equal time, users(:leonardo_bighi).remember_token_expires_at
  end

  test "should remember me default two weeks" do
    before = 2.weeks.from_now.utc

    users(:edgard).remember_me
    
    after = 2.weeks.from_now.utc
    
    assert_not_nil users(:edgard).remember_token
    assert_not_nil users(:edgard).remember_token_expires_at
    
    assert users(:edgard).remember_token_expires_at.between?(before, after)
  end

  test "should have many tasks" do
    assert_equal :has_many, User.reflect_on_association(:tasks).macro
  end
end