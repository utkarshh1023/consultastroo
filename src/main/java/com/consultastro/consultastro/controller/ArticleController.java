package com.consultastro.consultastro.controller;

import com.consultastro.consultastro.entity.Article;
import com.consultastro.consultastro.repository.ArticleRepository;
import com.consultastro.consultastro.services.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/articles")
@CrossOrigin
public class ArticleController {

    private final ArticleService service;

    public ArticleController(ArticleService service) {
        this.service = service;
    }

    @GetMapping
    public List<Article> getArticles(){
        return service.getArticles();
    }

    @PostMapping("/admin")
    public Article addArticle(@RequestBody Article article){
        return service.addArticle(article);
    }

    @DeleteMapping("/admin/{id}")
    public void deleteArticle(@PathVariable Long id){
        service.deleteArticle(id);
    }

}