require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  test "should belongs to user" do
    assert_equal :belongs_to, Task.reflect_on_association(:user).macro
  end

  test "should require description" do
    assert_no_difference "Task.count" do
      task_without_description = Task.create(:description => nil, :user => users(:maria_jose))

      assert !task_without_description.valid?
      assert task_without_description.new_record?
      assert_equal 1, task_without_description.errors.size
      assert_equal "can't be blank", task_without_description.errors.on(:description)
    end
  end

  test "should require description with no more than 90 characters" do
    assert_no_difference "Task.count" do
      task_with_description_with_91_characters =
        Task.create(:description =>  "Complete this website, make money with it, and buy smansions, ferraris and maybe a country.",
        :user => users(:elomar))

      assert !task_with_description_with_91_characters.valid?
      assert task_with_description_with_91_characters.new_record?
      assert_equal 1, task_with_description_with_91_characters.errors.size
      assert_equal "is too long (maximum is 90 characters)",
        task_with_description_with_91_characters.errors.on(:description)
    end
  end

  test "should require user" do
    assert_no_difference "Task.count" do
      task_without_user = Task.create(:description => "Make some exercise.", :user => nil)

      assert !task_without_user.valid?
      assert task_without_user.new_record?
      assert_equal 1, task_without_user.errors.size
      assert_equal "can't be blank", task_without_user.errors.on(:user)
    end
  end

  test "should create task" do
    assert_difference "Task.count" do
      valid_task = Task.create(:description => "Register the domain 2postit.com at dreamhost, and, if possible, host the domain there too.",
        :user => users(:fake_elomarns))

      assert valid_task.valid?
      assert_equal 0, valid_task.errors.size
      assert !valid_task.new_record?
    end
  end

  test "should set task to incomplete by default" do
    valid_task = Task.create(:description => "Play more World of Warcraft.",
      :user => users(:edgard))

    assert_equal false, valid_task.done
  end

  test "should set task to done" do
    learn_jquery_task = tasks(:learn_jquery)
    learn_jquery_task.update_attributes({ :done => true })

    assert tasks(:learn_jquery).done
  end
end