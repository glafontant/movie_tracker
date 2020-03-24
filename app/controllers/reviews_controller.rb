class ReviewsController < ApplicationController
  before_action :set_movie

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.create(review_params)
    return render :new if @review.errors.any?
    redirect_to movie_reviews_path @movie, notice: "Thank you for your Review!"
  end

  def index
    @reviews = @movie.reviews
  end

  private

    def review_params
      params.require(:review).permit(:name, :comment, :stars)
    end

    def set_movie
      return @movie if defined? @movie
      @movie = Movie.find(params[:movie_id])
    end
end
