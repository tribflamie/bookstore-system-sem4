/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;

import fpt.aptech.CattleManagement.entities.Comment;
import fpt.aptech.CattleManagement.repository.AuthRepository;
import fpt.aptech.CattleManagement.repository.CommentRepository;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

/**
 *
 * @author admin
 */
@Service
public class CommentService {
    @Autowired
    CommentRepository commentRepository;
     @Autowired
    AuthRepository userService;

    
    public List<Comment> FindAll(){
        return commentRepository.findAll();
    }
    // Phương thức để kiểm tra xem người dùng đã mua hàng hay chưa
   public boolean userHasPurchased(int userId) {
        return commentRepository.hasPurchased(userId);
    }
    
    // Phương thức để lưu một Comment
    public void saveComment(Comment comment, int userId) {
        // Kiểm tra xem người dùng đã mua hàng chưa
        if (userHasPurchased(userId)) {
            commentRepository.save(comment);
        } else {
            throw new RuntimeException("Người dùng phải mua hàng trước khi có thể bình luận.");
        }
    }
    
    public void save(Comment newcomment){
        commentRepository.save(newcomment);
    }
    
    public void deletecomment(int id){
      Comment comment = commentRepository.findById(id).get();
      commentRepository.delete(comment);
    }
    
     public Page<Comment> getAll(int pageNo) {
        Pageable pageable = PageRequest.of(pageNo - 1, 5);
        return commentRepository.findAllOrderByDescendingId(pageable);
    }
     
     
//      public double calculateAverageRating(Product product, List<Comment> comments) {
//        int sumRating = 0;
//        int countRating = 0;
//
//        for (Comment c : comments) {
//            if (c.getProductid().getId() == product.getId() && c.getRating() > 0) {
//                sumRating += c.getRating();
//                countRating++;
//            }
//        }
//
//        if (countRating > 0) {
//            return (double) sumRating / countRating;
//        } else {
//            return 0; // Trường hợp không có rating nào, trả về 0 hoặc giá trị mặc định khác
//        }
//    }
      
      public double calculateAverageRating(Integer productId) {
        List<Comment> reviews = commentRepository.findByProductidId(productId);

        if (reviews.isEmpty()) {
            return 0.0; // Trả về 0 nếu không có đánh giá nào
        }

        // Tính tổng điểm đánh giá
        double totalRating = reviews.stream().mapToDouble(Comment::getRating).sum();

        // Tính averageRating
        double averageRating = totalRating / reviews.size();

        return averageRating;
    }
      
       public List<Comment> getCommentsByProductId(Integer productId) {
        return commentRepository.findByProductidId(productId);
    }
       
        // Phương thức tính trung bình số sao đánh giá
@SuppressWarnings("unused")
private double calculateAverageRating(List<Comment> comments) {
    if (comments == null || comments.isEmpty()) {
        return 0;
    }

    int totalRating = 0;
    for (Comment comment : comments) {
        totalRating += comment.getRating();
    }

    return (double) totalRating / comments.size();
}
   
     
}
