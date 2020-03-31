class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    create_params = review_params.merge(user_id: current_user.id)
    @review = @movie.reviews.create(create_params)
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
      params.require(:review).permit(:comment, :stars)
    end

    def set_movie
      return @movie if defined? @movie
      @movie = Movie.find(params[:movie_id])
    end
end
