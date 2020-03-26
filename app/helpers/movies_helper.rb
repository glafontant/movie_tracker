module MoviesHelper

    def total_gross(movie)
      if movie.flop?
        "Flop!"
      else
        number_to_currency(movie.total_gross, precision: 0)
      end
    end

    def year_on(movie)
      movie.released_on.strftime("%Y")
    end

    def average_stars(movie)
      if movie.average_stars.zero?
        content_tag(:strong, "No Reviews")
      else
        "*" * movie.average_stars.round
      end
    end
end
