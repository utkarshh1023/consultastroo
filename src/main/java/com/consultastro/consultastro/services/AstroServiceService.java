package com.consultastro.consultastro.services;




import com.consultastro.consultastro.entity.AstroService;
import com.consultastro.consultastro.repository.AstroServiceRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.List;



@Service
public class AstroServiceService {

    private final AstroServiceRepository repo;

    public AstroServiceService(AstroServiceRepository repo){
        this.repo=repo;
    }

    public List<AstroService> getAllServices(){
        return repo.findAll();
    }

    public AstroService createService(AstroService service){
        return repo.save(service);
    }

    public void deleteService(Long id){
        repo.deleteById(id);
    }

}