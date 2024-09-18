/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Repository.java to edit this template
 */
package fpt.aptech.CattleManagement.repository;

import fpt.aptech.CattleManagement.entities.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

/**
 *
 * @author admin
 */
public interface AuthRepository extends JpaRepository<User, Integer> {
    User findByUsername(String username);
        User findByEmail(String email);
    boolean existsByEmail(String email);
    
    @Query("SELECT c FROM User c ORDER BY c.id DESC")
    Page<User> findAllOrderByDescendingId(Pageable pageable);
    
}
