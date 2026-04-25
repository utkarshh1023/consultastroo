package com.consultastro.consultastro.controller;

import com.consultastro.consultastro.dto.PaymentRequest;
import com.razorpay.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/payment")
@CrossOrigin
public class PaymentController {

    @Value("${razorpay.key}")
    private String key;

    @Value("${razorpay.secret}")
    private String secret;

    @PostMapping("/create-order")
    public Map<String, Object> createOrder(@RequestBody PaymentRequest request) throws RazorpayException {

        RazorpayClient client = new RazorpayClient(key, secret);

        JSONObject orderReq = new JSONObject();
        orderReq.put("amount", request.getAmount() * 100);
        orderReq.put("currency", "INR");
        orderReq.put("receipt", "txn_123");

        Order order = client.orders.create(orderReq);

        Map<String,Object> response = new HashMap<>();

        response.put("id", order.get("id"));
        response.put("amount", order.get("amount"));
        response.put("currency", order.get("currency"));

        return response;
    }
}