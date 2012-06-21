class Tag < ActiveRecord::Base
  belongs_to :hacker
  has_and_belongs_to_many :entries
  
  attr_accessible :hacker_id, :name
  validates :name, presence: true
  validates :hacker_id, numericality: { greater_than_or_equal_to: 1 }

  def to_s
    name
  end
  
  class << self
    def tag_usage(id)
      find_by_sql("SELECT id, name, count(e.entry_id) AS count
        FROM tags AS t LEFT OUTER JOIN entries_tags AS e ON e.tag_id = t.id
        WHERE t.hacker_id = " + id.to_s + 
        " GROUP BY t.name
        ORDER BY count DESC, name ASC;")
    end
  end

end
