class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  has_many :permissions
  has_many :comments

  has_secure_password

  validates :email, presence: true
  validates :authentication_token, uniqueness: true

  #@note @rails scopes
  # exemple : User.admins.by_name or User.by_name.admins

  scope :admins, -> { where(admin: true) }
  scope :by_name, -> { order(:name) }

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end

  before_create :ensure_authentication_token

  private
  def ensure_authentication_token
    begin
      self.authentication_token = Devise.friendly_token
    end while self.class.exists?(authentication_token: authentication_token)
  end
end

