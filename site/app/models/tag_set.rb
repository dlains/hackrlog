class TagSet < ActiveRecord::Base
  belongs_to :hacker
  attr_accessible :name, :tags, :hacker_id
  validates :name, presence: true
  validates :tags, presence: true
  validates :hacker_id, numericality: { greater_than_or_equal_to: 1 }
end
