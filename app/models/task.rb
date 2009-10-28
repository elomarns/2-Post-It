class Task < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :description
  validates_length_of :description, :maximum => 90, :allow_blank => true
  validates_presence_of :user
end