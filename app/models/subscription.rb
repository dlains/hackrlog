class Subscription < ActiveRecord::Base
  FREE_ENTRY_LIMIT = 50
  
  has_one :hacker
  
  def can_create_entry?
    if self.premium_account == true
      return true
    elsif self.hacker.entries.count < FREE_ENTRY_LIMIT + 1
      return true
    else
      return false
    end
  end
end
