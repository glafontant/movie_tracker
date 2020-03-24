class ReviewsController < ApplicationController
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.create(review_params)
    return render :new if @review.errors.any?
    redirect_to movie_reviews_url, notice: "Thank you for your Review!"
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    return render :edit if @review.errors.any?
    redirect_to movie_reviews_url, notice: "Review has been updated."
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to movie_reviews_url, danger: "Review successfully deleted!"
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
