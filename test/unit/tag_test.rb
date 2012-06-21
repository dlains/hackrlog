require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :tags
  
  test "tag attributes must not be empty" do
    tag = Tag.new
    assert tag.invalid?
    assert tag.errors[:hacker_id].any?
    assert tag.errors[:name].any?
  end
  
  test "hacker id must be positive" do
    tag = Tag.new(:name => "Bad Tag")
    tag.hacker_id = -1
    assert tag.invalid?
    assert_equal "must be greater than or equal to 1", tag.errors[:hacker_id].join("; ")
    
    tag.hacker_id = 0
    assert tag.invalid?
    assert_equal "must be greater than or equal to 1", tag.errors[:hacker_id].join("; ")
    
    tag.hacker_id = 1
    assert tag.valid?
  end

  test "name must contain a value" do
    tag = Tag.new(:hacker_id => 1)
    
    assert tag.invalid?
    assert_equal "can't be blank", tag.errors[:name].join("; ")
    
    tag.name = "Good Tag"
    assert tag.valid?
  end
  
end
