package edu.wccnet.hharris.studentApp.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import edu.wccnet.hharris.studentApp.entity.Checkout;

@Repository
public class CheckoutDAOImpl implements CheckoutDAO {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    @Transactional
    public List<Checkout> getCheckouts() {
        Session session = sessionFactory.getCurrentSession();

        Query<Checkout> query =
            session.createQuery("from Checkout", Checkout.class);

        return query.getResultList();
    }

    @Override
    @Transactional
    public Checkout getCheckout(int id) {
        Session session = sessionFactory.getCurrentSession();

        return session.get(Checkout.class, id);
    }

    @Override
    @Transactional
    public void saveCheckout(Checkout checkout) {
        Session session = sessionFactory.getCurrentSession();

        session.saveOrUpdate(checkout);
    }

    @Override
    @Transactional
    public void deleteCheckout(int id) {
        Session session = sessionFactory.getCurrentSession();

        Checkout checkout = session.get(Checkout.class, id);

        if (checkout != null) {
            session.delete(checkout);
        }
    }

    @Override
    @Transactional
    public List<Checkout> getCheckoutsByCustomerId(int customerId) {
        Session session = sessionFactory.getCurrentSession();

        Query<Checkout> query = session.createQuery(
            "from Checkout where customer.id = :custId", Checkout.class);

        query.setParameter("custId", customerId);

        return query.getResultList();
    }
}