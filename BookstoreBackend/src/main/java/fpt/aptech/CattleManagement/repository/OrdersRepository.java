/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Repository.java to edit this template
 */
package fpt.aptech.CattleManagement.repository;

import fpt.aptech.CattleManagement.entities.Orders;


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
public interface OrdersRepository extends JpaRepository<Orders, Integer> {

    @Query("SELECT c FROM Orders c ORDER BY c.id DESC")
    Page<Orders> findAllOrderByDescendingId(Pageable pageable);

    // Phương thức lấy các đơn hàng dựa trên ngày cập nhật
    List<Orders> findByUpdatedate(String updatedate);

    List<Orders> findByUpdatedateBetween(String fromDate, String toDate);

    @Query("SELECT c FROM Orders c WHERE c.updatedate BETWEEN :fromDate AND :toDate")
    List<Orders> findByUpdatedate(@Param("fromDate") String fromDate, @Param("toDate") String toDate);
    
     
}
