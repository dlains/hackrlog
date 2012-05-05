require 'test_helper'

class TagSetTest < ActiveSupport::TestCase
  fixtures :tag_sets
  
  test "tag set attributes must not be empty" do
    tag_set = TagSet.new
    assert tag_set.invalid?
    assert tag_set.errors[:name].any?
    assert tag_set.errors[:tags].any?
    assert tag_set.errors[:hacker_id].any?
  end
  
  test "hacker id must be positive" do
    tag_set = TagSet.new(name: "TagSetName", tags: "New, Tag")
    tag_set.hacker_id = -1
    assert tag_set.invalid?
    assert_equal "must be greater than or equal to 1", tag_set.errors[:hacker_id].join("; ")
    
    tag_set.hacker_id = 0
    assert tag_set.invalid?
    assert_equal "must be greater than or equal to 1", tag_set.errors[:hacker_id].join("; ")
    
    tag_set.hacker_id = 1
    assert tag_set.valid?
  end

  test "name must contain a value" do
    tag_set = TagSet.new(tags: "New, Tag", hacker_id: 1)
    
    assert tag_set.invalid?
    assert_equal "can't be blank", tag_set.errors[:name].join("; ")

    tag_set.name = " "
    assert_equal "can't be blank", tag_set.errors[:name].join("; ")
    
    tag_set.name = "TagSetName"
    assert tag_set.valid?
  end
  
  test "tags must contain a value" do
    tag_set = TagSet.new(name: "TagSetName", hacker_id: 1)
    
    assert tag_set.invalid?
    assert_equal "can't be blank", tag_set.errors[:tags].join("; ")

    tag_set.tags = " "
    assert_equal "can't be blank", tag_set.errors[:tags].join("; ")
    
    tag_set.tags = "New, Tag"
    assert tag_set.valid?
  end

end
