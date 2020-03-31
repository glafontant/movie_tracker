class User < ApplicationRecord
  has_secure_password

  has_many :reviews, dependent: :destroy

  validates :name, 
            presence: true

  validates :email, 
            presence: true, 
            format: { with: /\S+@\S+/, message: "not a valid format" },
            uniqueness: { case_sensitive: false },
            length: { minimum: 10, allow_blank: true }

  validates :username,
            format: { with: /\A[A-Z0-9]+\z/i },
            uniqueness: { case_sensitive: false}

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end
end
