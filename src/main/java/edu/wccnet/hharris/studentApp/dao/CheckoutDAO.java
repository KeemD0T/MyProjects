package edu.wccnet.hharris.studentApp.dao;

import java.util.List;

import edu.wccnet.hharris.studentApp.entity.Checkout;

public interface CheckoutDAO {

    List<Checkout> getCheckouts();

    Checkout getCheckout(int id);

    void saveCheckout(Checkout checkout);

    void deleteCheckout(int id);

    List<Checkout> getCheckoutsByCustomerId(int customerId);
}
