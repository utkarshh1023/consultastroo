package com.consultastro.consultastro.services;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendBookingEmail(String to,String name,String service){

        SimpleMailMessage message = new SimpleMailMessage();

        message.setTo(to);

        message.setSubject("ConsultASTRO Booking Confirmed");

        message.setText(
                "Hello "+name+
                        "\n\nYour booking for "+service+" consultation is confirmed.\n\nThank you for choosing ConsultASTRO."
        );

        mailSender.send(message);

    }

}