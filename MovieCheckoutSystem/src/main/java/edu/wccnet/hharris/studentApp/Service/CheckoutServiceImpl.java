package edu.wccnet.hharris.studentApp.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.wccnet.hharris.studentApp.dao.CheckoutDAO;
import edu.wccnet.hharris.studentApp.entity.Checkout;
import edu.wccnet.hharris.studentApp.dao.CustomerDAO;
import edu.wccnet.hharris.studentApp.dao.MovieDAO;
import edu.wccnet.hharris.studentApp.entity.Customer;
import edu.wccnet.hharris.studentApp.entity.Movie;

@Service
public class CheckoutServiceImpl implements CheckoutService {

    @Autowired
    private CheckoutDAO checkoutDAO;

    @Autowired
    private CustomerDAO customerDAO;

    @Autowired
    private MovieDAO movieDAO;
    
    @Override
    public List<Checkout> getCheckouts() {
        return checkoutDAO.getCheckouts();
    }

    @Override
    public List<Checkout> getCheckoutsByCustomerId(int customerId) {
        return checkoutDAO.getCheckoutsByCustomerId(customerId);
    }

    @Override
    public void saveCheckout(Checkout checkout) {
        checkoutDAO.saveCheckout(checkout);
    }

    @Override
    public Checkout getCheckout(int id) {
        return checkoutDAO.getCheckout(id);
    }

    @Override
    public void deleteCheckout(int id) {
        checkoutDAO.deleteCheckout(id);
    }
    
   @Override
    public void checkoutMovie(int customerId, int movieId) {

    	Customer customer = customerDAO.getCustomer(customerId);
    	Movie movie = movieDAO.getMovie(movieId);
    	
        if (customer == null) {
            throw new RuntimeException("Customer not found");
        }

        if (movie == null) {
            throw new RuntimeException("Movie not found");
        }

        if (movie.getAvailableCopies() <= 0) {
            throw new RuntimeException("No copies available");
        }

        Checkout checkout = new Checkout();
        checkout.setCustomer(customer);
        checkout.setMovie(movie);
        checkout.setCheckoutDate(new java.util.Date());
        checkout.setReturned(false);

        // decrease available copies
        movie.setAvailableCopies(movie.getAvailableCopies() - 1);

        checkoutDAO.saveCheckout(checkout);
        movieDAO.saveMovie(movie);
    }
   @Override
   public void returnMovie(int checkoutId) {

       Checkout checkout = checkoutDAO.getCheckout(checkoutId);

       if (checkout == null) {
           throw new RuntimeException("Checkout not found");
       }

       if (checkout.isReturned()) {
           throw new RuntimeException("Movie already returned");
       }

       Movie movie = checkout.getMovie();

       checkout.setReturned(true);
       checkout.setReturnDate(new java.util.Date());

       movie.setAvailableCopies(movie.getAvailableCopies() + 1);

       checkoutDAO.saveCheckout(checkout);
       movieDAO.saveMovie(movie);
   }
}