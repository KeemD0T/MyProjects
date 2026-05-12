package edu.wccnet.hharris.studentApp.controller;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import edu.wccnet.hharris.studentApp.Service.CheckoutService;
import edu.wccnet.hharris.studentApp.entity.Checkout;

@RestController
@RequestMapping("/api")
public class CheckoutRestController {

    @Autowired
    private CheckoutService checkoutService;

    @GetMapping("/checkouts")
    public List<Checkout> getCheckouts() {
        return checkoutService.getCheckouts();
    }

    @GetMapping("/checkouts/{checkoutId}")
    public Checkout getCheckout(@PathVariable int checkoutId) {
        Checkout checkout = checkoutService.getCheckout(checkoutId);

        if (checkout == null) {
            throw new RuntimeException("Checkout id not found: " + checkoutId);
        }

        return checkout;
    }

    @GetMapping("/customers/{customerId}/checkouts")
    public List<Checkout> getCheckoutsByCustomerId(@PathVariable int customerId) {
        return checkoutService.getCheckoutsByCustomerId(customerId);
    }

    @PostMapping("/checkouts/customers/{customerId}/movies/{movieId}")
    public String checkoutMovie(@PathVariable int customerId,
                                @PathVariable int movieId) {

        checkoutService.checkoutMovie(customerId, movieId);

        return "Checked out movie id " + movieId + " for customer id " + customerId;
    }

    @PostMapping("/checkouts/{checkoutId}/return")
    public String returnMovie(@PathVariable int checkoutId) {

        checkoutService.returnMovie(checkoutId);

        return "Returned checkout id " + checkoutId;
    }

    @DeleteMapping("/checkouts/{checkoutId}")
    public String deleteCheckout(@PathVariable int checkoutId) {
        Checkout checkout = checkoutService.getCheckout(checkoutId);

        if (checkout == null) {
            throw new RuntimeException("Checkout id not found: " + checkoutId);
        }

        checkoutService.deleteCheckout(checkoutId);

        return "Deleted checkout id: " + checkoutId;
    }
    @ExceptionHandler(CheckoutNotFoundException.class)
    public ResponseEntity<CheckoutErrorResponse> handleException(CheckoutNotFoundException e) {

        CheckoutErrorResponse error = new CheckoutErrorResponse();

        error.setStatus(HttpStatus.NOT_FOUND.value());
        error.setMessage(e.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<CheckoutErrorResponse> handleException(Exception e) {

        CheckoutErrorResponse error = new CheckoutErrorResponse();

        error.setStatus(HttpStatus.BAD_REQUEST.value());
        error.setMessage(e.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
    
}