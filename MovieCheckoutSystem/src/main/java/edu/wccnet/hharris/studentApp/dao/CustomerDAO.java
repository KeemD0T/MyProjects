package edu.wccnet.hharris.studentApp.dao;
import java.util.List;

import edu.wccnet.hharris.studentApp.entity.Customer;
import edu.wccnet.hharris.studentApp.entity.Checkout;

public interface CustomerDAO {

	public List<Customer> getCustomers();

	public void saveCustomer(Customer theCustomer);

    public Customer getCustomer(int id);

    public void deleteCustomer(int id);

	


	



	
}
