/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;

import fpt.aptech.CattleManagement.entities.Category;
import fpt.aptech.CattleManagement.entities.Comment;
import fpt.aptech.CattleManagement.entities.Product;
import fpt.aptech.CattleManagement.repository.CommentRepository;
import fpt.aptech.CattleManagement.repository.ProductRepository;
import java.util.List;
import java.util.Optional;
import java.util.OptionalDouble;
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
public class ProductService {

    @Autowired
    ProductRepository productRepository;
    @Autowired
    CommentRepository commentRepository;
    @Autowired
    OrdersService ordersService;

    public List<Product> FindAll() {
        return productRepository.findAll();
    }
    public Page<Product> getAll(int pageNo) {
        Pageable pageable = PageRequest.of(pageNo - 1, 5);
        return productRepository.findAllOrderByDescendingId(pageable);
    }

    public List<Product> searchByName(String productname) {
        return productRepository.findProductsByNameLike(productname);
    }

    public List<Product> findByIdCats(Category categoryid) {
        return productRepository.findByIdcat(categoryid);
    }

    public List<Product> findByPrice(double min, double max) {
        return productRepository.findByPrice(min, max);
    }

    public Product productbyId(int id) {
        return productRepository.findById(id).get();
    }
    

    public void saveproduct(Product newproduct) {
        productRepository.save(newproduct);
    }
    public Product updateProduct(Product upproduct) {
        return productRepository.save(upproduct);
    }
    public Product findbyId(int id) {
        return productRepository.findById(id).get();
    }
     // Phương thức service để kiểm tra sự tồn tại của categoryname
    public boolean existsByProductname(String productname) {
        return productRepository.existsByProductname(productname);
    }
    

    public void deleteproduct(int id) {
        Product productId = productRepository.findById(id).get();
        productRepository.delete(productId);
    }
    
     public int countProduct(){
       return (int) productRepository.count();
    }
     public Product updateOrderStatus(int id, String newActive) {
        Optional<Product> optionalOrder = productRepository.findById(id);
        if (optionalOrder.isPresent()) {
            Product order = optionalOrder.get();

            // Kiểm tra và chuyển đổi status
            if ("Out of stock".equals(order.getActive())) {
                order.setActive("Stocking");
            } else if ("Stocking".equals(order.getActive())) {
                order.setActive("Out of stock");
            } else {
                // Trường hợp khác nếu cần xử lý
                order.setActive(newActive);
            }

            return productRepository.save(order);
        }
        return null;
    }
     
     // Kiểm tra xem người dùng có mua sản phẩm hay không
    // Hàm tính trung bình rating của một sản phẩm
     public double calculateAverageRating(Integer productId) {
        List<Comment> ratings = commentRepository.findByProductidId(productId);
        
        OptionalDouble averageRating = ratings.stream()
                .mapToInt(Comment::getRating) // Adjusted to getRating based on your entity field
                .average();

        return averageRating.orElse(0.0);
    }
     
     public List<Product> getProductsByCategoryId(int categoryId) {
        return productRepository.findByCategoryid_Id(categoryId);
    }
     
     public boolean hasInactiveProducts(int categoryId) {
        List<Product> products = productRepository.findByCategoryid_Id(categoryId);

        for (Product product : products) {
            if ("Stocking".equals(product.getActive())) {
                return true; // Nếu có ít nhất một sản phẩm có trạng thái active là "Not", trả về true
            }
        }

        return false; // Nếu không có sản phẩm nào có trạng thái active là "Not", trả về false
    }

}
