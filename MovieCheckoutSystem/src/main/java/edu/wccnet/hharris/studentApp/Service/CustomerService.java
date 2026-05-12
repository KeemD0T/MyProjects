package edu.wccnet.hharris.studentApp.Service;

import java.util.List;
import edu.wccnet.hharris.studentApp.entity.Customer;

public interface CustomerService {

    List<Customer> getCustomers();

    void saveCustomer(Customer theCustomer);

    Customer getCustomer(int id);

    void deleteCustomer(int id);
}