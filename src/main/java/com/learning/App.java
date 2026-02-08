package com.learning;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.jpa.repository.JpaRepository;
// CHANGE THESE TWO LINES:
import javax.persistence.*; 
import java.util.List;

@SpringBootApplication
@RestController
public class App {
    // ... the rest of the code remains the same ...

    // Inject the Repository (The Database Tool)
    private final SurveyRepository repository;

    public App(SurveyRepository repository) {
        this.repository = repository;
    }

    // --- YOUR FAMILY GREETINGS (STILL HERE) ---
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

    // --- UPDATED SURVEY SYSTEM (NOW DATABASE PERSISTENT) ---
    
    // Changing path to /survey to make it easier for you to curl
    @PostMapping("/survey")
    public String submitSurvey(@RequestBody SurveyResponse data) {
        repository.save(data); // SAVES TO POSTGRES!
        return "Success! Survey saved in Database for: " + data.platform;
    }

    @GetMapping("/survey")
    public List<SurveyResponse> getResults() {
        return repository.findAll(); // PULLS FROM POSTGRES!
    }

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}

// --- THE DATA MODEL (MAPPED TO DATABASE TABLE) ---

@Entity
class SurveyResponse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id; // Database needs an ID

    public String email;
    public String platform;
    public int rating;
    public String comments;
}

// --- THE REPOSITORY INTERFACE ---
interface SurveyRepository extends JpaRepository<SurveyResponse, Long> {
}
