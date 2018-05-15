# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :username, :password_digest, :session_token, presence:true
  validates :username, :session_token, uniqueness: true
  validates :password, length: {minimum:6, allow_nil:true}
  attr_reader :password
  before_validation :ensure_token
  
  has_many :subs,
    foreign_key: :moderator_id,
    class_name: :Sub
  
  def ensure_token
    self.session_token ||= self.class.generate_token
  end
  
  def self.generate_token
    SecureRandom.urlsafe_base64
  end
  
  def reset_token!
    self.session_token = self.class.generate_token
    self.save!
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(username,password)
    user = User.find_by_username(username)
    user && user.is_password?(password) ? user : nil
  end
end
