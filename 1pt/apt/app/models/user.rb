class User < ApplicationRecord
  has_secure_password

  has_many :events

  def self.authenticate(username, password)
    @user = User.find_by username: username
    @user.authenticate password if @user
  end
end
