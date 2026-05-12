package edu.wccnet.hharris.studentApp.Service;

import java.util.List;

import edu.wccnet.hharris.studentApp.entity.Movie;

public interface MovieService {

    List<Movie> getMovies();

    void saveMovie(Movie movie);

    Movie getMovie(int id);

    void deleteMovie(int id);

    List<Movie> searchMovies(String keyword);

    Movie getMovieByTitle(String title);
}