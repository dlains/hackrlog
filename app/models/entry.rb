class Entry < ActiveRecord::Base
  belongs_to :hacker, inverse_of: :entries
  has_and_belongs_to_many :tags
  attr_accessible :content, :hacker_id, :tag_ids
  validates :content, presence: true
  validates :hacker_id, numericality: { greater_than_or_equal_to: 1 }

  class << self
    # The SQL query works as follows: The sub query selects all entries_tags records that have a tag_id
    # from one of the requested tags. What we want is only the entries that have ALL of the selected tags
    # so the sub query groups by the entry_id and the tag_ids are counted. The outter query then selects
    # only the rows where the count equals the number of tags requested. This removes rows where only
    # some of the tags were found.
    def entries_for_tags(hacker_id, tags, limit, offset)
      ids = find_by_sql(
        "SELECT id FROM
        (
          SELECT id, count(tag_id) AS count
          FROM entries AS e LEFT JOIN entries_tags AS j ON e.id = j.entry_id
          WHERE e.hacker_id = #{hacker_id} AND j.tag_id IN (#{tags.join(',')})
          GROUP BY id
          ORDER BY created_at DESC
        ) AS sub WHERE sub.count = #{tags.count}
        LIMIT #{limit} OFFSET #{offset};"
      )
      
      ids.collect! {|e| e.id}
      find(ids, order: 'created_at DESC')
    end
  end

  def export_csv
    content + '","' + tags.join(" ") + '","' + created_at.to_s + '","' + updated_at.to_s + '"'
  end
  
  def csv_header
    "Content,Tags,Created At,Updated At"
  end
  
  def export_json
    '{"entry":{"content":"' + content + '","tags":"' + tags.join(" ") + '","created_at:":"' + created_at.to_s + '","updated_at":"' + updated_at.to_s + '"}}'
  end
  
  def export_yml
    "Entry:\n  Content: #{content}\n  Tags: " + tags.join(" ") + "\n  Created: #{created_at.to_s}\n  Updated: #{updated_at.to_s}\n\n"
  end
  
  def export_txt
    "Content: #{content}\nTags: " + tags.join(" ") + "\nCreated: #{created_at.to_s}\nUpdated: #{updated_at.to_s}\n\n"
  end

end
