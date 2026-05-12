package edu.wccnet.hharris.studentApp.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.wccnet.hharris.studentApp.dao.MovieDAO;
import edu.wccnet.hharris.studentApp.entity.Movie;

@Service
public class MovieServiceImpl implements MovieService {

    @Autowired
    private MovieDAO movieDAO;

    @Override
    public List<Movie> getMovies() {
        return movieDAO.getMovies();
    }

    @Override
    public void saveMovie(Movie movie) {
        movieDAO.saveMovie(movie);
    }

    @Override
    public Movie getMovie(int id) {
        return movieDAO.getMovie(id);
    }

    @Override
    public void deleteMovie(int id) {
        movieDAO.deleteMovie(id);
    }

    @Override
    public List<Movie> searchMovies(String keyword) {
        return movieDAO.searchMovies(keyword);
    }

    @Override
    public Movie getMovieByTitle(String title) {
        return movieDAO.getMovieByTitle(title);
    }
}