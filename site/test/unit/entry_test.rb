require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  fixtures :entries
  
  test "entry attributes must not be empty" do
    entry = Entry.new
    assert entry.invalid?
    assert entry.errors[:hacker_id].any?
    assert entry.errors[:content].any?
  end
  
  test "hacker id must be positive" do
    entry = Entry.new(:content => "This is the content of the entry.")
    entry.hacker_id = -1
    assert entry.invalid?
    assert_equal "must be greater than or equal to 1", entry.errors[:hacker_id].join("; ")
    
    entry.hacker_id = 0
    assert entry.invalid?
    assert_equal "must be greater than or equal to 1", entry.errors[:hacker_id].join("; ")
    
    entry.hacker_id = 1
    assert entry.valid?
  end
  
  test "content must contain a value" do
    entry = Entry.new(:hacker_id => 1)
    
    assert entry.invalid?
    assert_equal "can't be blank", entry.errors[:content].join("; ")
    
    entry.content = "This would be another attempt at writing a note."
    assert entry.valid?
  end
  
end
