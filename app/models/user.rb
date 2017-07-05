class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true

  def self.find_by_credentials(email, password)
    user = find_by(email: email)
    user if user && user.authenticate(password)
  end

  def generate_auth_token
    payload = { user_id: id }
    AuthToken.encode(payload)
  end
end
