/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;

import fpt.aptech.CattleManagement.entities.Category;
import fpt.aptech.CattleManagement.repository.CategoryRepository;
import java.util.List;
import java.util.Optional;
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
public class CategoryService {

    @Autowired
    CategoryRepository categoryRepository;
    @Autowired
    ProductService productService;
    @Autowired
    public CategoryService(CategoryRepository categoryRepository,ProductService productService) {
        this.categoryRepository = categoryRepository;
        this.productService=productService;
    }


    public List<Category> FindAll() {
        return categoryRepository.findAll();
    }
    public Page<Category> getAll(int pageNo) {
        Pageable pageable = PageRequest.of(pageNo - 1, 5);
        return categoryRepository.findAllOrderByDescendingId(pageable);
    }

    public Category findbyId(int id) {
        return categoryRepository.findById(id).get();
    }

     public void save(Category newCategory) {
        // Kiểm tra xem categoryname đã tồn tại trong cơ sở dữ liệu chưa
       

        // Nếu chưa tồn tại, tiến hành lưu vào cơ sở dữ liệu
        categoryRepository.save(newCategory);
    }
     // Phương thức service để kiểm tra sự tồn tại của categoryname
    public boolean existsByCategoryname(String categoryname) {
        return categoryRepository.existsByCategoryname(categoryname);
    }
    

    public Category updateCategory(Category upcategory) {
       
        return categoryRepository.save(upcategory);
    }

    public void deletecate(int id) {
        Category c = categoryRepository.findById(id).get();
        categoryRepository.delete(c);
    }
    public Category updateOrderStatus(int id, String newStatus) {
        Optional<Category> optionalOrder = categoryRepository.findById(id);
        if (optionalOrder.isPresent()) {
            Category order = optionalOrder.get();

            // Kiểm tra và chuyển đổi status
            if ("Not Activated".equals(order.getStatus())) {
                order.setStatus("Activated");
            } else if ("Activated".equals(order.getStatus())) {
                order.setStatus("Not Activated");
            } else {
                // Trường hợp khác nếu cần xử lý
                order.setStatus(newStatus);
            }

            return categoryRepository.save(order);
        }
        return null;
    }
    
//     public boolean hasActiveProducts(int categoryId) {
//    List<Product> products = productService.getProductsByCategoryId(categoryId);
//    
//    for (Product product : products) {
//        if (product.getActive().equals("Not Activated")) {
//            return true; // Nếu có ít nhất một sản phẩm đang hoạt động, trả về true
//        }
//    }
//    
//    return false; // Nếu không có sản phẩm nào đang hoạt động, trả về false
//}
}
