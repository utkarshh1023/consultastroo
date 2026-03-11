package com.consultastro.consultastro.services;


import com.consultastro.consultastro.entity.Article;
import com.consultastro.consultastro.repository.ArticleRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ArticleService {

    private final ArticleRepository repo;

    public ArticleService(ArticleRepository repo) {
        this.repo = repo;
    }

    public List<Article> getArticles(){
        return repo.findAll();
    }

    public Article addArticle(Article article){
        return repo.save(article);
    }

    public void deleteArticle(Long id){
        repo.deleteById(id);
    }

}