/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;

import fpt.aptech.CattleManagement.entities.Blog;
import fpt.aptech.CattleManagement.repository.BlogRepository;
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
public class BlogService {

    @Autowired
    BlogRepository blogRepository;

    public List<Blog> FindAll() {
        return blogRepository.findAll();
    }

    public Blog findbyId(int id) {
        return blogRepository.findById(id).get();
    }

    public void save(Blog newblog) {
        blogRepository.save(newblog);
    }
     // Phương thức service để kiểm tra sự tồn tại của categoryname
    public boolean existsByName(String blogname) {
        return blogRepository.existsByName(blogname);
    }

    public Blog updateblog(Blog upblog) {
        return blogRepository.save(upblog);
    }

    public void deleteblog(int id) {
        Blog blogdelete = blogRepository.findById(id).get();
        blogRepository.delete(blogdelete);
    }
    
    public Page<Blog> getAll(int pageNo) {
        Pageable pageable = PageRequest.of(pageNo - 1, 5);
        return blogRepository.findAllOrderByDescendingId(pageable);
    }
    
    public Blog updateOrderStatus(int id, String newActive) {
        Optional<Blog> optionalOrder = blogRepository.findById(id);
        if (optionalOrder.isPresent()) {
            Blog order = optionalOrder.get();

            // Kiểm tra và chuyển đổi status
            if ("Not Activated".equals(order.getActive())) {
                order.setActive("Activated");
            } else if ("Activated".equals(order.getActive())) {
                order.setActive("Not Activated");
            } else {
                // Trường hợp khác nếu cần xử lý
                order.setActive(newActive);
            }

            return blogRepository.save(order);
        }
        return null;
    }
    
   
}
