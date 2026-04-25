package com.consultastro.consultastro.controller;

import com.consultastro.consultastro.entity.Booking;
import com.consultastro.consultastro.services.BookingService;
import com.consultastro.consultastro.services.EmailService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/booking")
@CrossOrigin
public class BookingController {

    private final BookingService service;
    private final EmailService emailService;

    public BookingController(BookingService service, EmailService emailService) {
        this.service = service;
        this.emailService = emailService;
    }

    @PostMapping
    public Booking book(@RequestBody Booking booking){

        Booking savedBooking = service.createBooking(booking);

        // send confirmation email
        emailService.sendBookingEmail(
                booking.getEmail(),
                booking.getName(),
                booking.getService()
        );

        return savedBooking;
    }

    @GetMapping("/admin")
    public List<Booking> getBookings(){
        return service.getBookings();
    }

}