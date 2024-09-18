/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Repository.java to edit this template
 */
package fpt.aptech.CattleManagement.repository;

import fpt.aptech.CattleManagement.entities.Blog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 *
 * @author admin
 */
public interface BlogRepository extends JpaRepository<Blog, Integer> {
    
     // Phương thức kiểm tra sự tồn tại của name
    boolean existsByName(String name);
    
    @Query("SELECT c FROM Blog c ORDER BY c.id DESC")
    Page<Blog> findAllOrderByDescendingId(Pageable pageable);
}
