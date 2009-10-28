require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  test "should require description" do
    assert_no_difference 'Task.count' do
      task_without_description = Task.create(:description => nil, :user => users(:maria_jose))

      assert !task_without_description.valid?
      assert task_without_description.new_record?
      assert_equal 1, task_without_description.errors.size
      assert_equal "can't be blank", task_without_description.errors.on(:description)
    end
  end

  test "should require description with less than 90 characters" do
    assert_no_difference 'Task.count 'do
      task_with_long_description = 
        Task.create(:description => "Complete this app, make money with it, buy a mansion and a ferrari, and make more money to buy more ferraris.",
        :user => users(:elomar))

      assert !task_with_long_description.valid?
      assert task_with_long_description.new_record?
      assert_equal 1, task_with_long_description.errors.size
      assert_equal "is too long (maximum is 90 characters)", task_with_long_description.errors.on(:description)
    end
  end

  test "should require user" do
    assert_no_difference 'Task.count' do
      task_without_user = Task.create(:description => "Make some exercise.", :user => nil)

      assert !task_without_user.valid?
      assert task_without_user.new_record?
      assert_equal 1, task_without_user.errors.size
      assert_equal "can't be blank", task_without_user.errors.on(:user)
    end
  end

  test "should create task" do
    assert_difference 'Task.count' do
      valid_task = Task.create(:description => "Register the domain 2postit.com.",
        :user => users(:fake_elomarns))

      assert valid_task.valid?
      assert_equal 0, valid_task.errors.size
      assert !valid_task.new_record?
    end
  end

  test "should set a task to incomplete by default" do
    valid_task = Task.create(:description => "Read the book \"Don\'t make me Think\".",
      :user => users(:marcos_gurgel))

    assert_equal false, valid_task.done
  end

  test "should set existent task to done" do
    learn_jquery_task = tasks(:learn_jquery)
    learn_jquery_task.update_attributes({ :done => true })

    assert tasks(:learn_jquery).done
  end

end