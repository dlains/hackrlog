class Hacker < ActiveRecord::Base
  has_many :entries, inverse_of: :hacker, dependent: :destroy
  belongs_to :subscription, dependent: :delete
  
  has_secure_password
  attr_accessible :email, :name, :time_zone, :password, :password_confirmation, :save_tags, :highlight_style
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, confirmation: true
  validates_presence_of :password_confirmation, if: :password_provided?
  validates_presence_of :time_zone

  before_create { 
    generate_token(:auth_token)
    add_free_subscription
  }

  attr_accessor :stripe_card_token

  # Override to_xml to prevent sending sensitive data.
  def to_xml(options = {})
    default_only = [:id, :email, :name, :time_zone, :created_at, :updated_at]
    options[:only] = (options[:only] || []) + default_only
    super(options)
  end

  # Create an entry for the given user. Checks premium status and free limits.
  def create_entry(entry_attrs)
    if subscription.can_create_entry?
      entry_attrs['hacker_id'] = self.id
      Entry.create! entry_attrs
    end
  end
  
  # Upgrade existing account to hackrLog() Premium.
  def update_with_premium(params)
    if valid?
      customer = StripeService.create_customer(self, params[:stripe_card_token])
      
      if customer != nil
        self.subscription.premium_account = true
        self.subscription.premium_start_date = Date.today
        self.subscription.stripe_customer_token = customer.id
        self.subscription.save!
      else
        logger.error "Stripe customer creation failed for hacker: #{self.email}."
        return false
      end
    end
    return true
  end
  
  # Cancel the hacker's account and remove their entries.
  # Cancel the Stripe Customer Subscription if this is a premium account.
  def cancel_account
    if self.subscription.premium_account
      StripeService.cancel_customer_subscription(self)
    end

    Notifier.account_closed(self).deliver
  end
    
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    Notifier.password_reset(self).deliver
  end
  
  def enable_beta_access
    self.password = self.password_confirmation = generate_password
    self.beta_access = true
    Notifier.beta_access_request(self).deliver
  end
  
  def activate_beta_access
    generate_token(:password_reset_token)
    save!
    Notifier.activate_beta_access(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Hacker.exists?(column => self[column])
  end
  
  def create_initial_data
    # Text for the first log entry.
    # TODO: Update this before going live.
    # TODO: Include pointers to markdown help.
    content = "## Welcome to _hackrLog()_\n\nThis is your first entry. You can edit it by clicking the Edit button, or delete it with the Delete button and start fresh with a new note.\n\n### Getting Started\n\nWith _hackrLog()_ you don't manage your notes and ideas in pages, you separate each discreet note or idea into a log entry and tag it with keywords that will help you locate it again in the future. This will give you much more flexibility when categorizing your notes and finding them later.\n\nTags are simple words, anything that will help you categorize your entries. There are a couple of simple rules to use when adding a tag to an entry:\n\n* Spaces within tags are not allowed. 'web services' would be considered two tags whereas 'web-services' would be a single tag.\n* Tags are all converted to lower case. If you use upper case characters when entering your tags they will be changed to lower case.\n\nThe list of tags you have used appears on the left side of the page. If you wish to filter the _hackrLog()_ entries on the page, simply click the on / off switch next to the tag. You will see all the entries on the page will contain that tag and the tag list will only contain tags used by the filtered entries. Activating two or more tags will filter the shown entries further.\n\nTry creating your first entry now. Enter any text you like in the __Log Entry__ field at the top of the page and enter 'first entry' in the __Tags__ field. Click the __Create__ button or simply press the enter key and your first _hackrLog()_ entry will be created.\n\nFor additional ideas on how to use tags and categorize your entries see the [Help](https://www.hackrlog.com/home/help) page."
      
    # Create the first entry now that the tags have been created.
    self.entries.build({
      content: content,
      tag_ids: [Tag.find_by_name("todo").id]
    })
    save!
  end

  private

  def add_free_subscription
    self.subscription = Subscription.create!
  end
  
  def password_provided?
    self.password != "" && self.password != nil
  end

  def generate_password
    (0...10).map{65.+(rand(25)).chr}.join
  end
  
end
