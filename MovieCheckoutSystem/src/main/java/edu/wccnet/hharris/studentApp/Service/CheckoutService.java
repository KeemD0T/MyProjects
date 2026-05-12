package edu.wccnet.hharris.studentApp.Service;

import java.util.List;
import edu.wccnet.hharris.studentApp.entity.Checkout;

public interface CheckoutService {

    List<Checkout> getCheckouts();

    List<Checkout> getCheckoutsByCustomerId(int customerId);

    void saveCheckout(Checkout checkout);

    Checkout getCheckout(int id);

    void deleteCheckout(int id);

	void checkoutMovie(int customerId, int movieId);

	void returnMovie(int checkoutId);
}