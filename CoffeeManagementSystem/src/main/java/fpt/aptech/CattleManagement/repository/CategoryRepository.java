/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Repository.java to edit this template
 */
package fpt.aptech.CattleManagement.repository;

import fpt.aptech.CattleManagement.entities.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 *
 * @author admin
 */
public interface CategoryRepository extends JpaRepository<Category, Integer> {
    Category findByCategoryname(String categoryname);
    // Phương thức kiểm tra sự tồn tại của categoryname
    boolean existsByCategoryname(String categoryname);
     // Tìm kiếm tất cả các danh mục và sắp xếp theo ID giảm dần
    @Query("SELECT c FROM Category c ORDER BY c.id DESC")
    Page<Category> findAllOrderByDescendingId(Pageable pageable);
}
