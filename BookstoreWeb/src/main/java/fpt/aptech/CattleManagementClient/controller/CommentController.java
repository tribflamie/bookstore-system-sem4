/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.dto.PageDto;
import fpt.aptech.CattleManagementClient.entities.Comment;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

/**
 *
 * @author AnhLinh
 */
@Controller
public class CommentController {
    private String urlcomment = "http://localhost:9999/api/comment";
     private RestTemplate rest = new RestTemplate();
    
    @RequestMapping("/comment")
public String function_allFeedback(Model model, HttpSession session, @RequestParam(defaultValue = "1") Integer pageNo) {
    // Truy xuất tên người dùng từ phiên làm việc
    String username = (String) session.getAttribute("username");
    if (username == null) {
        return "redirect:/login";
    }

    // Kiểm tra vai trò của người dùng
    switch (username) {
        case "Admin":
        case "Employee":
            // Gọi API để lấy danh sách người dùng
            ResponseEntity<PageDto<Comment>> response = rest.exchange(
                urlcomment + "/allcomment?pageNo=" + pageNo,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<PageDto<Comment>>() {});

            if (response.getStatusCode() == HttpStatus.OK) {
                PageDto<Comment> pageDto = response.getBody();

                // Thêm thông tin vào model
                model.addAttribute("username", username);
                model.addAttribute("list", pageDto.getContent());
                model.addAttribute("totalPages", pageDto.getTotalPages());
                model.addAttribute("totalElements", pageDto.getTotalElements());
                model.addAttribute("currentPage", pageNo);

                // Calculate page numbers
                List<Integer> pageNumbers = IntStream.rangeClosed(1, pageDto.getTotalPages()).boxed().collect(Collectors.toList());
                model.addAttribute("pageNumbers", pageNumbers);

                return "Admin/comment/index";
            } else {
                // Handle error here
                return "error";
            }
        default:
            return "redirect:/comment";
    }
    
    
}
@GetMapping("/deletecomment/{id}")
    public String Delete(@PathVariable int id, Model model) {
        String decategoryurl = urlcomment + "/" + id;
        try {
            rest.exchange(decategoryurl, HttpMethod.DELETE, null, String.class);
            return "redirect:/comment";
        } catch (Exception e) {
            return "Error/errorPage";
        }
    }
    
}
