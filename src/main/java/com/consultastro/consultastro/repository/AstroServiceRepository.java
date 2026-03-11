package com.consultastro.consultastro.repository;

import com.consultastro.consultastro.entity.AstroService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AstroServiceRepository extends JpaRepository<AstroService,Long> {

}
