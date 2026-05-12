package edu.wccnet.hharris.studentApp.controller;

public class CheckoutNotFoundException extends RuntimeException {
	  
	public CheckoutNotFoundException(String msg) {
        super(msg);
	    }
}
