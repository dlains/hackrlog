class Hacker < ActiveRecord::Base
  has_many :entries, :inverse_of => :hacker
  has_many :tag_sets

  attr_accessible :email, :name, :time_zone, :password, :password_confirmation, :save_tags
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, confirmation: true
  validates_presence_of :password_confirmation, :if => :password_provided?
  validates_presence_of :time_zone
  has_secure_password

  # Override to_xml to prevent sending sensitive data.
  def to_xml(options = {})
    default_only = [:id, :email, :name, :time_zone, :created_at, :updated_at]
    options[:only] = (options[:only] || []) + default_only
    super(options)
  end

  private

  def password_provided?
    password != "" && password != nil
  end

end
