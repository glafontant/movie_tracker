class User < ApplicationRecord
  has_secure_password

  before_save :set_username
  before_save :set_email

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

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

  scope :by_name, -> { order(name: :asc) }
  scope :non_admins, -> { by_name.where(admin: false) }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  private

  def set_username
    self.username = username.downcase
  end

  def set_email
    self.email = email.downcase
  end
end
