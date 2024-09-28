/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.dto.PageDto;
import fpt.aptech.CattleManagementClient.entities.Feedback;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author ASUS
 */
@Controller
@RequestMapping("/admin/feedbacks")
public class FeedbackController {
     private final String apiUrl = "http://localhost:9999/api/feedbackcontroller/";
      @SuppressWarnings("unused")
    private String urlproductcart = "http://localhost:9999/api/productcart";
      RestTemplate restTemplate = new RestTemplate();
    
    @GetMapping("/all")
    public String function_allFeedback(Model model, @RequestParam(defaultValue = "1") Integer pageNo) {
        ResponseEntity<PageDto<Feedback>> response = restTemplate.exchange(
                apiUrl + "allfeed?pageNo=" + pageNo,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<PageDto<Feedback>>() {
        }
        );

        if (response.getStatusCode() == HttpStatus.OK) {

            PageDto<Feedback> pageDto = response.getBody();

            model.addAttribute("feedback", pageDto.getContent());
            model.addAttribute("totalPages", pageDto.getTotalPages());
            model.addAttribute("totalElements", pageDto.getTotalElements());
            model.addAttribute("currentPage", pageNo);
            //lấy ngày giờ hiện tại
            //model.addAttribute("msg","Today's : "+ new Date());
            // Calculate page numbers
            List<Integer> pageNumbers = IntStream.rangeClosed(1, pageDto.getTotalPages()).boxed().collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);

            return "Admin/feedback/index";
        } else {
            // Handle error here
            return "error";
        }
    }
    @PostMapping("/save")
    public String saveFeedback( Feedback feedback) {
        // Set the appropriate headers for the request
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Create an HttpEntity with the Feedback object and headers
        HttpEntity<Feedback> requestEntity = new HttpEntity<>(feedback, headers);

        // Make a POST request to save the feedback
        @SuppressWarnings("unused")
        ResponseEntity<String> responseEntity = restTemplate.postForEntity(apiUrl + "save", requestEntity, String.class);

        // Redirect to the feedback list page
        return "redirect:/contactus";
    }
    @GetMapping("/deletefeedback/{id}")
    public String Delete(@PathVariable int id, Model model) {
        String decategoryurl = apiUrl + "/" + id;
        try {
            restTemplate.exchange(decategoryurl, HttpMethod.DELETE, null, String.class);
            return "redirect:/admin/feedbacks/all";
        } catch (Exception e) {
            return "Error/errorPage";
        }
    }
    
     @PostMapping("/updateFeedbackStatus/{id}")
    public String updateOrderStatus(@PathVariable("id") int id,
            @RequestParam("status") String newStatus,
            RedirectAttributes redirectAttributes) {
        String updateUrl = apiUrl + "/updateStatus/{id}?status={status}";

        // Prepare HTTP headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Create HTTP entity with updated status
        HttpEntity<String> requestEntity = new HttpEntity<>(headers);

        try {
            // Send POST request to update status
            ResponseEntity<String> response = restTemplate.exchange(
                    updateUrl,
                    HttpMethod.POST,
                    requestEntity,
                    String.class,
                    id,
                    newStatus
            );

            // Check response status
            if (response.getStatusCode() == HttpStatus.OK) {
                redirectAttributes.addFlashAttribute("Activated",true);
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to update status");
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error: " + ex.getMessage());
        }

        return "redirect:/admin/feedbacks/all" ; // Redirect to order details page
    }
    
}
