class Task < ActiveRecord::Base
  validates_presence_of :description
  validates_length_of :description, :maximum => 90, :allow_blank => true
end