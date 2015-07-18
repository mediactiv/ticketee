class User < ActiveRecord::Base


  has_many :permissions

  has_secure_password

  validates :email, presence: true

  #@note @rails scopes
  # exemple : User.admins.by_name or User.by_name.admins

  scope :admins, -> { where(admin: true) }

  scope :by_name, -> { order(:name) }



  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end
end
