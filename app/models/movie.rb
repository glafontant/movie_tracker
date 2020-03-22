class Movie < ApplicationRecord

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

    has_many :reviews, dependent: :destroy

    class << self
      def released
        where("released_on < ?", Time.now).order(released_on: :desc)
      end

      def hits
        where("total_gross >= ?", 300000000).order(total_gross: :desc)
      end

      def flops
        where("total_gross < ?", 225000000)
      end

      def recently_added
        order(created_at: :desc).limit(3)
      end
    end

    def flop?
        total_gross < 225_000_000
    end
end
