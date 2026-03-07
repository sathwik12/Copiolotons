package com.learning;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.jpa.repository.JpaRepository;
import javax.persistence.*; 
import java.util.List;

@SpringBootApplication
@RestController
public class App {

    private final SurveyRepository repository;

    public App(SurveyRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/")
    public String sayHello() {
        return "Hello Kanna I Love You! Shravya(Kanna) Agasthya Sharma Sathwik Sharma";
    }

    @GetMapping("/about")
    public String aboutPage() {
        return "Kanna i am starting to build an aplication using Docker for learning DevOps";
    }

    @GetMapping("/hello")
    public String greetUser(@RequestParam(value = "name", defaultValue = "Student") String name) {
        return "Hey Docker, " + name + "! I want to learn this in a perfect manner";
    }

    @PostMapping("/survey")
    public String submitSurvey(@RequestBody SurveyResponse data) {
        repository.save(data); 
        return "Success! Survey saved in Database for: " + data.platform;
    }

    @GetMapping("/survey")
    public List<SurveyResponse> getResults() {
        return repository.findAll();
    }

    // --- NEW ENDPOINT: SEARCH BY PLATFORM ---
    // Usage: GET /survey/search?platform=Docker
    @GetMapping("/survey/search")
    public List<SurveyResponse> getResultsByPlatform(@RequestParam String platform) {
        return repository.findByPlatform(platform);
    }

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}

@Entity
class SurveyResponse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    public String email;
    public String platform;
    public int rating;
    public String comments;
}

// --- UPDATED REPOSITORY INTERFACE ---
interface SurveyRepository extends JpaRepository<SurveyResponse, Long> {
    // Spring Data JPA automatically creates the SQL query based on this name!
    List<SurveyResponse> findByPlatform(String platform);
}
