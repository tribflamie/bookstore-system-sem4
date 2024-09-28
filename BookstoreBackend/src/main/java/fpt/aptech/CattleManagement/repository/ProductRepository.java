/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Repository.java to edit this template
 */
package fpt.aptech.CattleManagement.repository;

import fpt.aptech.CattleManagement.entities.Category;
import fpt.aptech.CattleManagement.entities.Product;
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
public interface ProductRepository extends JpaRepository<Product, Integer> {

    @Query("SELECT p FROM Product p WHERE p.sale BETWEEN :min AND :max")
    List<Product> findByPrice(@Param("min") double min, @Param("max") double max);

    @Query("SELECT p FROM Product p WHERE p.categoryid= :categoryid")
    List<Product> findByIdcat(@Param("categoryid") Category categoryid);

    @Query(value = "SELECT * FROM Product p WHERE p.productname LIKE %:productName%", nativeQuery = true)
    List<Product> findProductsByNameLike(@Param("productName") String productName);
//    List<Product> findByProductname(String productName);
    @Query("SELECT p FROM Product p ORDER BY p.id DESC")
    Page<Product> findAllOrderByDescendingId(Pageable pageable);
    // Phương thức kiểm tra sự tồn tại của productname
    boolean existsByProductname(String productname);
    
   List<Product> findByCategoryid_Id(int categoryId);
}
