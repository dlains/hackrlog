class Hacker < ActiveRecord::Base
  has_many :entries
  has_many :tags

  attr_accessible :email, :enabled, :name, :time_zone
  validates :email, presence: true, uniqueness: true, email: true
  validates_presence_of :time_zone
  has_secure_password
end
