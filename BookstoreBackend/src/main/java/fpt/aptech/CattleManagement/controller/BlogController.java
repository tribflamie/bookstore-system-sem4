/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;

import fpt.aptech.CattleManagement.dto.PageDto;
import fpt.aptech.CattleManagement.entities.Blog;
import fpt.aptech.CattleManagement.service.BlogService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 *
 * @author admin
 */
@RestController
@RequestMapping("/api/blog")
public class BlogController {

    @Autowired
    BlogService blogService;

    @GetMapping()
    @ResponseStatus(HttpStatus.OK)
    public List<Blog> findallcategory() {
        return blogService.FindAll();
    }
    
    @GetMapping("/allblog")
    public ResponseEntity<PageDto<Blog>> getAllCategories(
            @RequestParam(defaultValue = "1") int pageNo
            
    ) {
        Page<Blog> categoryPage = blogService.getAll(pageNo);

        PageDto<Blog> pageDto = new PageDto<>();
        pageDto.setContent(categoryPage.getContent());
        pageDto.setTotalPages(categoryPage.getTotalPages());
        pageDto.setTotalElements(categoryPage.getTotalElements());

        return ResponseEntity.ok(pageDto);
    }
    

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Blog findbyidblog(@PathVariable int id) {
        return blogService.findbyId(id);
    }
    

    @PostMapping("/createblog")
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<Void>savecategory(@RequestBody Blog newblog) {
        // Kiểm tra xem categoryname đã tồn tại hay chưa
        boolean exists = blogService.existsByName(newblog.getName());
        if (exists) {
            // Nếu categoryname đã tồn tại, trả về ResponseEntity với HttpStatus.CONFLICT
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        } else {
            // Nếu categoryname chưa tồn tại, thực hiện lưu mới Category và trả về HttpStatus.CREATED
           
            blogService.save(newblog);
            // Ví dụ danh sách các Category
        
            return ResponseEntity.status(HttpStatus.CREATED).build();
        }
          
        
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteblog(@PathVariable int id) {
        blogService.deleteblog(id);
    }

    @PutMapping("/editblog")
@ResponseStatus(HttpStatus.OK)
public ResponseEntity<Blog> editblog(@RequestBody Blog updateblog) {
    // Lấy thông tin blog hiện tại từ cơ sở dữ liệu
    Blog currentBlog = blogService.findbyId(updateblog.getId());

    // Kiểm tra nếu name mới khác với name hiện tại và đã tồn tại trong database
    if (!updateblog.getName().equals(currentBlog.getName()) &&
            blogService.existsByName(updateblog.getName())) {
        // Nếu name đã tồn tại và không phải của chính blog đang chỉnh sửa, trả về HttpStatus.CONFLICT
        return ResponseEntity.status(HttpStatus.CONFLICT).build();
    } else {
        // Nếu name chưa tồn tại hoặc là của chính blog đang chỉnh sửa, tiến hành cập nhật và trả về HttpStatus.OK
        Blog updatedBlog = blogService.updateblog(updateblog);
        return ResponseEntity.ok(updatedBlog);
    }
}

    
    @PostMapping("/updateStatus/{id}")
    public ResponseEntity<String> updateOrderStatus(@PathVariable("id") int id, @RequestParam("active") String newActive) {
        Blog updatedOrder = blogService.updateOrderStatus(id, newActive);

        if (updatedOrder != null) {
            return ResponseEntity.ok("Status updated successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
