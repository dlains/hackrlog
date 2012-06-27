class Tag < ActiveRecord::Base
  has_and_belongs_to_many :entries
  
  attr_accessible :name
  validates :name, presence: true
  validates :name, format: { with: /\A[^\s]*\z/ }
  def to_s
    name
  end
  
  class << self
    
    # Get a list of all tags used by the logged in hacker.
    def current_hacker_tags(hacker)
      find_by_sql("SELECT DISTINCT t.* FROM tags AS t
        JOIN entries_tags AS et ON et.tag_id = t.id
        JOIN entries AS e ON e.id = et.entry_id
        WHERE e.hacker_id = #{hacker}
        ORDER BY t.name;")
    end
    
    # Get a list of all tags used by the given entries.
    def tags_used_by(entries)
      ids = []
      unless entries.blank?
        entries.each {|entry| ids << entry.id}
        find_by_sql("SELECT DISTINCT t.* FROM tags AS t
          JOIN entries_tags AS et ON et.tag_id = t.id
          WHERE et.entry_id IN (#{ids.join(',')})
          ORDER BY t.name;")
      end
    end

    # Get a list tags and a count of their usage for the tag manager.
    def tag_usage(hacker)
      find_by_sql("SELECT t.id, t.name, count(et.entry_id) AS count
        FROM tags AS t 
        LEFT OUTER JOIN entries_tags AS et ON et.tag_id = t.id
        LEFT OUTER JOIN entries AS e ON et.entry_id = e.id
        WHERE e.hacker_id = #{hacker}
        GROUP BY t.name
        ORDER BY count DESC, name ASC;")
    end
  end

end
