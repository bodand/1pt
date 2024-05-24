class User < ApplicationRecord
  has_secure_password

  has_many :events

  validates :username,
            presence: true,
            uniqueness: true,
            format: UsernameFormat
  validates :password,
            presence: true
  validates :name,
            presence: true,
            format: RealNameFormat
  validates :email,
            presence: true,
            uniqueness: true,
            format: EmailFormat

  def self.authenticate(username, password)
    @user = User.find_by username: username
    @user.authenticate password if @user
  end
end
