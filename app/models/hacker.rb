class Hacker < ActiveRecord::Base
  has_many :entries, inverse_of: :hacker

  has_secure_password
  attr_accessible :email, :name, :time_zone, :password, :password_confirmation, :save_tags
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, confirmation: true
  validates_presence_of :password_confirmation, if: :password_provided?
  validates_presence_of :time_zone

  before_create { generate_token(:auth_token) }

  attr_accessor :stripe_card_token

  # Override to_xml to prevent sending sensitive data.
  def to_xml(options = {})
    default_only = [:id, :email, :name, :time_zone, :created_at, :updated_at]
    options[:only] = (options[:only] || []) + default_only
    super(options)
  end

  def update_with_premium(params)
    if valid?
      customer = Stripe::Customer.create(email: self.email, plan: 'hackrlog_1', card: params[:stripe_card_token])
      self.premium_active = true
      self.premium_start_date = Date.today
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}."
    errors.add :base, "There was a problem processing your credit card."
    false
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
    content = "## Welcome to __hackrLog__\n\nThis is your first note. You can edit it by clicking the 'Edit' link to the left, or delete it and start fresh with a new note.\n\n### Getting Started\n\nEnter new notes at the top of the page. Notes appear in this list, newest first. As more notes are added a stream of information is created that can become very long.\n\nThis is where Tags become useful. Tags can be created automatically by adding them to a note or manually in the Tag Manager on the right. Tags are case sensative and can have spaces. Separate tags in the form with commas.\n\nWhen you wish to find a particular note or set of notes click a Tag name, either in a note or in the Tag Manager on the right. You will see a list of notes which contain the selected Tag. You will also be able to add additional Tags to refine your note selection.\n"
      
    # Create the first entry now that the tags have been created.
    self.entries.build({
      content: content,
      tag_ids: [Tag.find_by_name("todo").id]
    })
    save!
  end

  private

  def password_provided?
    self.password != "" && self.password != nil
  end

  def generate_password
    (0...10).map{65.+(rand(25)).chr}.join
  end
  
end
