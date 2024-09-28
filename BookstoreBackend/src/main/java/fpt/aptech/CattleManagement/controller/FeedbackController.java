/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;

import fpt.aptech.CattleManagement.dto.PageDto;
import fpt.aptech.CattleManagement.entities.Feedback;
import fpt.aptech.CattleManagement.service.FeedbackService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 *
 * @author ASUS
 */
@RestController
@RequestMapping("/api/feedbackcontroller")
public class FeedbackController {
     private final FeedbackService feedbackService;

    @Autowired
    public FeedbackController(FeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }

    @PostMapping("/save")
    public ResponseEntity<String> function_saveFeedback(@RequestBody Feedback newFeedback) {
        feedbackService.saveFeedback(newFeedback);
        feedbackService.sendFeedback(newFeedback);
        return new ResponseEntity<>("Feedback saved successfully", HttpStatus.OK);
    }
     @GetMapping("/all")
    public ResponseEntity<List<Feedback>> function_getAllFeedbacks() {
        List<Feedback> allFeedbacks = feedbackService.findAllFeedback();
        return new ResponseEntity<>(allFeedbacks, HttpStatus.OK);
    }

   
     @GetMapping("/allfeed")
    public PageDto<Feedback> getAllFeedback(
            @RequestParam(defaultValue = "1") int pageNo
            ) {
        Page<Feedback> feedbackPage = feedbackService.getAll(pageNo);

        PageDto<Feedback> pageDto = new PageDto<>();
        pageDto.setContent(feedbackPage.getContent());
        pageDto.setTotalPages(feedbackPage.getTotalPages());

        return pageDto;
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  
    public void deletefeedback(@PathVariable int id) {
        feedbackService.deletefeedback(id);
    }
    @GetMapping("/search")
    public ResponseEntity<List<Feedback>> searchFeedback(@RequestParam("sender") String sender) {
        List<Feedback> searchedServices = feedbackService.searchServices(sender);
        return new ResponseEntity<>(searchedServices, HttpStatus.OK);
    }
     @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Feedback findbyidcategory(@PathVariable int id) {
        return feedbackService.findbyId(id);
    }
    
    @PostMapping("/updateStatus/{id}")
    public ResponseEntity<String> updateOrderStatus(@PathVariable("id") int id, @RequestParam("status") String newStatus) {
        Feedback updatedOrder = feedbackService.updateFeedbackStatus(id, newStatus, true);

        if (updatedOrder != null) {
            return ResponseEntity.ok("Status updated successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
