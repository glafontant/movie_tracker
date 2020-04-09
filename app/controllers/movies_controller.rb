class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

    def index
      @movies = Movie.send(movies_filter)
    end

    def show
        @fans = @movie.fans
        @genres = @movie.genres
        @favorite = current_user.favorites.find_by(movie_id: @movie.id) if current_user
    end

    def edit; end

    def update
      @movie.update(movie_params)
      return render :edit if @movie.errors.any?
      redirect_to @movie, notice: "Movie successfully updated!"
    end

    def new
      @movie = Movie.new
    end

    def create
      @movie = Movie.create(movie_params)
      return render :new if @movie.errors.any?
      redirect_to @movie, notice: "Movie successfully created!"
    end

    def destroy
      @movie.destroy
      redirect_to movies_url, danger: "Movie successfully deleted!"
    end

    private

    def movie_params
      params.require(:movie).
        permit(:title, :rating, :total_gross, :description, :released_on,
               :director, :duration, :image_file_name, genre_ids: [])
    end

    def movies_filter
      if params[:filter].in? %w(upcoming recent hits flops)
        params[:filter]
      else
        :released
      end
    end

    def set_movie
      return @movie if defined? @movie
      @movie = Movie.find_by!(slug: params[:id])
    end
end
