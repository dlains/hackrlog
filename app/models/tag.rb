class Tag < ActiveRecord::Base
  has_and_belongs_to_many :entries

  attr_accessible :name
  validates :name, presence: true
  validates :name, format: { with: /\A[^\s]*\z/ }

  def to_s
    name
  end
  
  class << self
    
    # Convert tag names to tag ids for the entry.
    def process_tag_names(params)
      return unless params.has_key?(:tags)
      
      ids = []
      tag_names = params[:tags].split(" ").collect! { |name| name.strip.downcase }

      tag_names.each do |name|
        tag = Tag.find_by_name(name)
        if tag != nil
          ids << tag.id
        else
          new_tag = Tag.new
          new_tag.name = name
          new_tag.save!
          ids << new_tag.id
        end
      end
      return ids.uniq
    end
    
    # Get a count of tags used by user.
    def current_hacker_tag_count(hacker_id)
      result = find_by_sql("SELECT COUNT(*) AS used
        FROM (SELECT DISTINCT tag_id FROM entries_tags AS et
        JOIN entries AS e ON e.id = et.entry_id
        WHERE e.hacker_id = #{hacker_id}) AS sub;")
      return result.first.used
    end

    # Get a list of all tags used by the logged in hacker.
    def current_hacker_tags(hacker_id)
      find_by_sql("SELECT DISTINCT t.* FROM tags AS t
        JOIN entries_tags AS et ON et.tag_id = t.id
        JOIN entries AS e ON e.id = et.entry_id
        WHERE e.hacker_id = #{hacker_id}
        ORDER BY t.name;")
    end
    
    # Get a list of all tags used in entries containing the given tags.
    def filtered_hacker_tags(tags, hacker_id)
      find_by_sql("SELECT t.* FROM tags AS t
        JOIN entries_tags AS et ON et.tag_id = t.id
        WHERE et.entry_id IN
          (SELECT entry_id FROM
            (SELECT et.entry_id, count(et.entry_id) as count
              FROM entries_tags AS et
              JOIN entries AS e ON e.id = et.entry_id
              WHERE et.tag_id IN (#{tags.join(',')})
              AND e.hacker_id = #{hacker_id}
              GROUP BY et.entry_id)
            AS sub
            WHERE sub.count = #{tags.count})
        GROUP BY t.id
        ORDER BY t.name ASC;")
    end

  end

end
