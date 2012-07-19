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
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Hacker.exists?(column => self[column])
  end
  
  private

  def password_provided?
    self.password != "" && self.password != nil
  end

end
