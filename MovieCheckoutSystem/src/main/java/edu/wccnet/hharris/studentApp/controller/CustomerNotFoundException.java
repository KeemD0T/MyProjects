package edu.wccnet.hharris.studentApp.controller;

public class CustomerNotFoundException extends RuntimeException {

    public CustomerNotFoundException(String msg) {
        super(msg);
    }
}