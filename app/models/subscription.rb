class Subscription < ActiveRecord::Base
  FREE_ENTRY_LIMIT = 50
  
  has_one :hacker
  
  def can_create_entry?
    if self.premium_account == true
      return true
    elsif self.hacker.entries.count < FREE_ENTRY_LIMIT
      return true
    else
      return false
    end
  end
  
  def at_limit?
    if self.premium_account == true
      return false
    elsif self.hacker.entries.count >= FREE_ENTRY_LIMIT
      return true
    else
      return false
    end
  end
end
