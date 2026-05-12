package edu.wccnet.hharris.studentApp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import edu.wccnet.hharris.studentApp.Service.MovieService;
import edu.wccnet.hharris.studentApp.entity.Movie;

@RestController
@RequestMapping("/api")
public class MovieRestController {

    @Autowired
    private MovieService movieService;

    @GetMapping("/movies")
    public List<Movie> getMovies() {
        return movieService.getMovies();
    }

    @GetMapping("/movies/{movieId}")
    public Movie getMovie(@PathVariable int movieId) {
        Movie movie = movieService.getMovie(movieId);

        if (movie == null) {
            throw new MovieNotFoundException("Movie id not found: " + movieId);
        }

        return movie;
    }

    @GetMapping("/movies/title/{title}")
    public Movie getMovieByTitle(@PathVariable String title) {
        Movie movie = movieService.getMovieByTitle(title);

        if (movie == null) {
            throw new MovieNotFoundException("Movie title not found: " + title);
        }

        return movie;
    }

    @GetMapping("/movies/search/{keyword}")
    public List<Movie> searchMovies(@PathVariable String keyword) {
        return movieService.searchMovies(keyword);
    }

    @PostMapping("/movies")
    public Movie addMovie(@RequestBody Movie movie) {
        movie.setId(0);
        movieService.saveMovie(movie);
        return movie;
    }

    @DeleteMapping("/movies/{movieId}")
    public String deleteMovie(@PathVariable int movieId) {
        Movie movie = movieService.getMovie(movieId);

        if (movie == null) {
            throw new MovieNotFoundException("Movie id not found: " + movieId);
        }

        movieService.deleteMovie(movieId);

        return "Deleted movie id: " + movieId;
    }

    @ExceptionHandler(MovieNotFoundException.class)
    public ResponseEntity<MovieErrorResponse> handleException(MovieNotFoundException e) {
        MovieErrorResponse error = new MovieErrorResponse();

        error.setStatus(HttpStatus.NOT_FOUND.value());
        error.setMessage(e.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<MovieErrorResponse> handleException(Exception e) {
        MovieErrorResponse error = new MovieErrorResponse();

        error.setStatus(HttpStatus.BAD_REQUEST.value());
        error.setMessage(e.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
}