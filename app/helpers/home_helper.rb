module HomeHelper

  def create_hacker
    @hacker = Hacker.new
  end

  def active?(tab)
    if controller.action_name.casecmp(tab) == 0
      'active'
    else
      'inactive'
    end
  end
  
end
