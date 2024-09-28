/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;

import fpt.aptech.CattleManagement.dto.PageDto;
import fpt.aptech.CattleManagement.entities.Comment;
import fpt.aptech.CattleManagement.service.CommentService;
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
 * @author admin
 */
@RestController
@RequestMapping("/api/comment")
public class CommentController {
    @Autowired
    CommentService commentService;

    @GetMapping()
    @ResponseStatus(HttpStatus.OK)
    public List<Comment> findallcomment() {
        return commentService.FindAll();
    }
    @GetMapping("/allcomment")
    public PageDto<Comment> getAllFeedback(
            @RequestParam(defaultValue = "1") int pageNo
            ) {
        Page<Comment> commentPage = commentService.getAll(pageNo);

        PageDto<Comment> pageDto = new PageDto<>();
        pageDto.setContent(commentPage.getContent());
        pageDto.setTotalPages(commentPage.getTotalPages());

        return pageDto;
    }

    @PostMapping("/createcomment")
    @ResponseStatus(HttpStatus.CREATED)
    public void savecomment(@RequestBody Comment newcomment) {
        Comment conment = new Comment();
        conment.setUserId(newcomment.getUserId());
        commentService.save(newcomment);
    }
//     @PostMapping("/createcomment")
//    public ResponseEntity<String> saveComment(@RequestBody Comment comment, @RequestParam int userId) {
//        try {
//            commentService.saveComment(comment, userId);
//            return ResponseEntity.ok("Đã lưu bình luận thành công.");
//        } catch (RuntimeException e) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
//        }
//    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)  
    public void deletecomment(@PathVariable int id) {
        commentService.deletecomment(id);
    }
//      @GetMapping("/averageRating/{productId}")
//    public ResponseEntity<Double> calculateAverageRating(@PathVariable int productId) {
//        Product product = new Product();
//        product.setId(productId); // Định nghĩa lại Product nếu cần
//
//        List<Comment> comments = commentService.FindAll(); // Lấy danh sách tất cả comment
//        double averageRating = commentService.calculateAverageRating(product, comments);
//
//        return ResponseEntity.ok(averageRating);
//    }
    @GetMapping("/{productId}")
    public ResponseEntity<Double> getAverageRating(@PathVariable Integer productId) {
        double averageRating = commentService.calculateAverageRating(productId);
        return ResponseEntity.ok(averageRating);
    }
     
}
