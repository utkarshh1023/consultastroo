package com.consultastro.consultastro.config;

import com.consultastro.consultastro.entity.Admin;
import com.consultastro.consultastro.entity.AstroService;
import com.consultastro.consultastro.repository.AdminRepository;
import com.consultastro.consultastro.repository.AstroServiceRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataLoader {

    @Bean
    CommandLineRunner init(AstroServiceRepository repo, AdminRepository adminRepository, PasswordEncoder passwordEncoder){

        return args -> {

            if(repo.count()==0){

                AstroService s1 = new AstroService();
                s1.setTitle("Kundli Reading");
                s1.setDescription("Complete birth chart analysis");
                s1.setPrice(999);

                AstroService s2 = new AstroService();
                s2.setTitle("Career Astrology");
                s2.setDescription("Career guidance through astrology");
                s2.setPrice(799);

                AstroService s3 = new AstroService();
                s3.setTitle("Love & Relationship");
                s3.setDescription("Relationship compatibility");
                s3.setPrice(899);

                repo.save(s1);
                repo.save(s2);
                repo.save(s3);

            }

            // Create default admin if none exists
            if(adminRepository.count() == 0){
                Admin admin = new Admin();
                admin.setEmail("admin@astro.com");
                admin.setPassword(passwordEncoder.encode("admin123"));
                adminRepository.save(admin);
            }

        };

    }
}