/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Repository.java to edit this template
 */
package fpt.aptech.CattleManagement.repository;

import fpt.aptech.CattleManagement.entities.Comment;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 *
 * @author admin
 */
public interface CommentRepository extends JpaRepository<Comment, Integer> {
    @Query("SELECT c FROM Comment c ORDER BY c.id DESC")
    Page<Comment> findAllOrderByDescendingId(Pageable pageable);
   // Tìm tất cả bình luận cho một sản phẩm cụ thể
    List<Comment> findByProductidId(Integer productId);

    // Tìm tất cả bình luận do một người dùng cụ thể viết
    List<Comment> findByUserIdId(Integer userId);
    // Đoạn truy vấn để kiểm tra xem người dùng có userId đã mua hàng hay chưa
    @Query("SELECT CASE WHEN COUNT(c) > 0 THEN true ELSE false END FROM Comment c WHERE c.userId = :userId")
    boolean hasPurchased(@Param("userId") int userId);
}
