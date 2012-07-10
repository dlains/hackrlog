class Hacker < ActiveRecord::Base
  has_many :entries, :inverse_of => :hacker
  has_many :tag_sets

  has_secure_password
  attr_accessible :email, :name, :time_zone, :password, :password_confirmation, :save_tags
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, confirmation: true
  validates_presence_of :password_confirmation, :if => :password_provided?
  validates_presence_of :time_zone

  before_create { generate_token(:auth_token) }
  
  # Override to_xml to prevent sending sensitive data.
  def to_xml(options = {})
    default_only = [:id, :email, :name, :time_zone, :created_at, :updated_at]
    options[:only] = (options[:only] || []) + default_only
    super(options)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Hacker.exists?(column => self[column])
  end
  
  private

  def password_provided?
    password != "" && password != nil
  end

end
