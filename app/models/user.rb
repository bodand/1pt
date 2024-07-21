class User < ApplicationRecord
  has_secure_password

  has_many :events

  validates :username,
            presence: true,
            uniqueness: true,
            format: UsernameFormat
  validates :password,
            presence: true,
            on: :create
  validates :name,
            presence: true,
            format: RealNameFormat
  validates :email,
            presence: true,
            uniqueness: true,
            format: EmailFormat

  def self.authenticate(username, password)
    @user = User.find_by username: username
    return nil unless @user
    return nil unless @user.authenticate password
    @user
  end
end
