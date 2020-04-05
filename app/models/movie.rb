class Movie < ApplicationRecord
    has_many :reviews, -> { order(:created_at, :desc) }, dependent: :destroy
    has_many :critics, through: :reviews, source: :user
    has_many :favorites, dependent: :destroy
    has_many :fans, through: :favorites, source: :user
    has_many :characterizations, dependent: :destroy
    has_many :genres, through: :characterizations

    RATINGS = %w(G PG PG-13 R NC-17)
    
    validates :title, :released_on, presence: true
    validates :description, length: { minimum: 25 }
    validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
    validates :image_file_name, format: {
      with: /\w+\.(jpg|png)\z/i,
      message: "must be a JPG or PNG image"
    }
    validates :rating, inclusion: { in: RATINGS,
      message: "is not a valid rating"}

    scope :released, -> { where("released_on < ?", Time.now).order(released_on: :desc) }
    scope :hits, -> { where("total_gross >= ?", 300000000).order(total_gross: :desc) }
    scope :flops, -> { where("total_gross < ?", 225000000) }
    scope :recently_added, ->(max=3) { order(created_at: :desc).limit(max) }
    scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :asc) }
    scope :recent, ->(max=5) { released.limit(max) }
    scope :grossed_less_than, ->(amount) { released.where("total_gross < ?", amount) }
    scope :grossed_greater_than, ->(amount) { released.where("total_gross > ?", amount) }

    def cult?
      reviews.count > 50 && reviews.average(:stars).to_f >= 4.0
    end

    def flop?
        total_gross < 225_000_000 && !cult?
    end

    def average_stars
      # nil will be converted to 0.0
      reviews.average(:stars).to_f
    end

    def average_stars_as_percent
      (average_stars / 5.0) * 100
    end
end
