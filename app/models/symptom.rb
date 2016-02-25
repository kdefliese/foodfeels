class Symptom < ActiveRecord::Base
  belongs_to :days
  belongs_to :users
  validates :name, presence: true
  validates :start_time, presence: true
end
