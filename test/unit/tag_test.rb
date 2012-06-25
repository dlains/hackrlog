require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :tags
  
  test "tag attributes must not be empty" do
    tag = Tag.new
    assert tag.invalid?
    assert tag.errors[:name].any?
  end
  
  test "name must contain a value" do
    tag = Tag.new
    
    assert tag.invalid?
    assert_equal "can't be blank", tag.errors[:name].join("; ")
    
    tag.name = "good"
    assert tag.valid?
  end

  test "name must not contain spaces" do
    tag = Tag.new(name: "bad space tag")
    
    assert tag.invalid?
    assert_equal "is invalid", tag.errors[:name].join("; ")
    
    tag.name = "bad_space_tag"
    assert tag.valid?
  end
  
end
