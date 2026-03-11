package com.consultastro.consultastro.controller;

import com.consultastro.consultastro.entity.AstroService;
import com.consultastro.consultastro.repository.AstroServiceRepository;
import com.consultastro.consultastro.services.AstroServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/services")
@CrossOrigin("*")
public class AstroServiceController {

    private final AstroServiceService service;

    public AstroServiceController(AstroServiceService service){
        this.service=service;
    }

    @GetMapping
    public List<AstroService> getServices(){
        return service.getAllServices();
    }

    @PostMapping("/admin")
    public AstroService addService(@RequestBody AstroService s){
        return service.createService(s);
    }

    @DeleteMapping("/admin/{id}")
    public void deleteService(@PathVariable Long id){
        service.deleteService(id);
    }

}