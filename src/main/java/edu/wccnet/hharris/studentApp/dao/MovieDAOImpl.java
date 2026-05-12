package edu.wccnet.hharris.studentApp.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import edu.wccnet.hharris.studentApp.entity.Movie;

@Repository
public class MovieDAOImpl implements MovieDAO {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    @Transactional
    public List<Movie> getMovies() {
        Session session = sessionFactory.getCurrentSession();

        Query<Movie> query = session.createQuery(
            "from Movie order by title", Movie.class);

        return query.getResultList();
    }

    @Override
    @Transactional
    public Movie getMovie(int id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(Movie.class, id);
    }

    @Override
    @Transactional
    public void saveMovie(Movie movie) {
        Session session = sessionFactory.getCurrentSession();
        session.saveOrUpdate(movie);
    }

    @Override
    @Transactional
    public void deleteMovie(int id) {
        Session session = sessionFactory.getCurrentSession();

        Movie movie = session.get(Movie.class, id);

        if (movie != null) {
            session.delete(movie);
        }
    }

    @Override
    @Transactional
    public List<Movie> searchMovies(String keyword) {
        Session session = sessionFactory.getCurrentSession();

        Query<Movie> query = session.createQuery(
            "from Movie where lower(title) like :keyword or lower(description) like :keyword order by title",
            Movie.class);

        query.setParameter("keyword", "%" + keyword.toLowerCase() + "%");

        return query.getResultList();
    }

    @Override
    @Transactional
    public Movie getMovieByTitle(String title) {
        Session session = sessionFactory.getCurrentSession();

        Query<Movie> query = session.createQuery(
            "from Movie where lower(title) = :title", Movie.class);

        query.setParameter("title", title.toLowerCase());

        List<Movie> results = query.getResultList();

        if (results.isEmpty()) {
            return null;
        }

        return results.get(0);
    }
}