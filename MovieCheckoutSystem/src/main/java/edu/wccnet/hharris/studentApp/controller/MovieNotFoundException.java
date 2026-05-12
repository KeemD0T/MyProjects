package edu.wccnet.hharris.studentApp.controller;

public class MovieNotFoundException extends RuntimeException {
	
	public MovieNotFoundException(String msg) {
        super(msg);
	    }
}
