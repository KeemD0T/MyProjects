package edu.wccnet.hharris.studentApp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import edu.wccnet.hharris.studentApp.Service.CheckoutService;
import edu.wccnet.hharris.studentApp.Service.CustomerService;
import edu.wccnet.hharris.studentApp.Service.MovieService;
import edu.wccnet.hharris.studentApp.entity.Customer;
import edu.wccnet.hharris.studentApp.entity.Movie;

@Controller
@RequestMapping("/movie")
public class MainController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private MovieService movieService;

    @Autowired
    private CheckoutService checkoutService;

    @GetMapping("/list")
    public String listMovies(Model model) {
        model.addAttribute("movies", movieService.getMovies());
        model.addAttribute("customers", customerService.getCustomers());
        return "list-movies";
    }
    @GetMapping("/search")
    public String searchMovies(@RequestParam("keyword") String keyword, Model model) {
        model.addAttribute("movies", movieService.searchMovies(keyword));
        model.addAttribute("customers", customerService.getCustomers());
        model.addAttribute("keyword", keyword);
        return "list-movies";
    }
    @GetMapping("/customers")
    public String listCustomers(Model model) {
        model.addAttribute("customers", customerService.getCustomers());
        return "list-customers";
    }
    @GetMapping("/showFormForAdd")
    public String showFormForAdd(Model model) {
        model.addAttribute("movie", new Movie());
        return "movie-form";
    }
    @GetMapping("/showCustomerFormForAdd")
    public String showCustomerFormForAdd(Model model) {
        model.addAttribute("customer", new Customer());
        return "customer-form";
    }

    @PostMapping("/saveCustomer")
    public String saveCustomer(@ModelAttribute("customer") Customer customer) {
        customerService.saveCustomer(customer);
        return "redirect:/movie/customers";
    }
    @PostMapping("/saveMovie")
    public String saveMovie(@ModelAttribute("movie") Movie movie) {
        movieService.saveMovie(movie);
        return "redirect:/movie/list";
    }

    @PostMapping("/checkout")
    public String checkoutMovie(@RequestParam("customerId") int customerId,
                                @RequestParam("movieId") int movieId) {
        checkoutService.checkoutMovie(customerId, movieId);
        return "redirect:/movie/list";
    }

    @PostMapping("/return")
    public String returnMovie(@RequestParam("checkoutId") int checkoutId) {
        checkoutService.returnMovie(checkoutId);
        return "redirect:/movie/list";
    }

    @GetMapping("/history")
    public String checkoutHistory(@RequestParam("customerId") int customerId,
                                  Model model) {
        model.addAttribute("customer", customerService.getCustomer(customerId));
        model.addAttribute("checkouts", checkoutService.getCheckoutsByCustomerId(customerId));
        return "checkout-history";
    }
}