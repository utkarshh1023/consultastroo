package com.consultastro.consultastro.services;

import com.consultastro.consultastro.entity.Booking;
import com.consultastro.consultastro.repository.BookingRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookingService {

    private final BookingRepository repo;

    public BookingService(BookingRepository repo) {
        this.repo = repo;
    }

    public Booking createBooking(Booking booking){
        return repo.save(booking);
    }

    public List<Booking> getBookings(){
        return repo.findAll();
    }

}