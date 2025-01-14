# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  biography       :text
#  location        :string
#  privacy         :boolean          default(TRUE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :email, :session_token, presence: true, uniqueness: true 
  validates :password_digest, :name, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password
  after_initialize :ensure_session_token
  
  # associations

  has_one_attached :photo
  has_many :created_projects,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: 'Project'
  
  has_many :backings,
    foreign_key: :backer_id,
    class_name: 'Backing'
  
  has_many :rewards, 
    through: :backings,
    source: :reward
  
  has_many :backed_projects,
    through: :rewards,
    source: :project
  
  # model specific methods
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end


  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

end
