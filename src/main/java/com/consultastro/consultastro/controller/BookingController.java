package com.consultastro.consultastro.controller;

import com.consultastro.consultastro.entity.Booking;
import com.consultastro.consultastro.repository.BookingRepository;
import com.consultastro.consultastro.services.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/booking")
@CrossOrigin
public class BookingController {

    private final BookingService service;

    public BookingController(BookingService service) {
        this.service = service;
    }

    @PostMapping
    public Booking book(@RequestBody Booking booking){
        return service.createBooking(booking);
    }

    @GetMapping("/admin")
    public List<Booking> getBookings(){
        return service.getBookings();
    }

}