/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;

import fpt.aptech.CattleManagement.dto.PageDto;
import fpt.aptech.CattleManagement.entities.Category;
import fpt.aptech.CattleManagement.service.CategoryService;
import fpt.aptech.CattleManagement.service.ProductService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 *
 * @author admin
 */
@RestController
@RequestMapping("/api/category")
public class CategoryController {

    @Autowired
    CategoryService categoryService;
    @Autowired
    ProductService productService;

    @Autowired
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping()
    @ResponseStatus(HttpStatus.OK)
    public List<Category> findallcategory() {
        return categoryService.FindAll();
    }

    @GetMapping("/allcategory")
    public ResponseEntity<PageDto<Category>> getAllCategories(
            @RequestParam(defaultValue = "1") int pageNo
    ) {
        Page<Category> categoryPage = categoryService.getAll(pageNo);

        PageDto<Category> pageDto = new PageDto<>();
        pageDto.setContent(categoryPage.getContent());
        pageDto.setTotalPages(categoryPage.getTotalPages());
        pageDto.setTotalElements(categoryPage.getTotalElements());

        return ResponseEntity.ok(pageDto);
    }

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Category findbyidcategory(@PathVariable int id) {
        return categoryService.findbyId(id);
    }

    @PostMapping("/Createcategory")
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<Void> savecategory(@RequestBody Category newcategory) {

        // Kiểm tra xem categoryname đã tồn tại hay chưa
        boolean exists = categoryService.existsByCategoryname(newcategory.getCategoryname());
        if (exists) {
            // Nếu categoryname đã tồn tại, trả về ResponseEntity với HttpStatus.CONFLICT
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        } else {
            // Nếu categoryname chưa tồn tại, thực hiện lưu mới Category và trả về HttpStatus.CREATED
            categoryService.save(newcategory);
            // Ví dụ danh sách các Category

            return ResponseEntity.status(HttpStatus.CREATED).build();
        }
    }

//    @PostMapping("/Createcategory")
//    @ResponseStatus(HttpStatus.CREATED)
//    public void savecategory(@RequestBody Category newcategory) {
//        categoryService.save(newcategory);
//    }
    // Endpoint để kiểm tra sự tồn tại của categoryname
    @GetMapping("/Checkcategoryname/{categoryname}")
    public ResponseEntity<Void> checkCategorynameExists(@PathVariable String categoryname) {
        boolean exists = categoryService.existsByCategoryname(categoryname);
        if (exists) {
            return ResponseEntity.ok().build(); // Trả về HttpStatus.OK nếu tồn tại
        } else {
            return ResponseEntity.notFound().build(); // Trả về HttpStatus.NOT_FOUND nếu không tồn tại
        }
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deletecategory(@PathVariable int id) {
        categoryService.deletecate(id);
    }

//    @PutMapping("/editcategory")
//    @ResponseStatus(HttpStatus.OK)
//    public Category editcategory(@RequestBody Category updatecategory) {
//        return categoryService.updateCategory(updatecategory);
//    }
    @PutMapping("/editcategory")
@ResponseStatus(HttpStatus.OK)
public ResponseEntity<Category> editcategory(@RequestBody Category updatecategory) {
    // Lấy thông tin danh mục hiện tại từ cơ sở dữ liệu
    Category currentCategory = categoryService.findbyId(updatecategory.getId());

    // Kiểm tra nếu categoryname mới khác với categoryname hiện tại và đã tồn tại trong database
    if (!updatecategory.getCategoryname().equals(currentCategory.getCategoryname()) &&
            categoryService.existsByCategoryname(updatecategory.getCategoryname())) {
        // Nếu categoryname đã tồn tại và không phải của chính category đang chỉnh sửa, trả về HttpStatus.CONFLICT
        return ResponseEntity.status(HttpStatus.CONFLICT).build();
    } else {
        // Nếu categoryname chưa tồn tại hoặc là của chính category đang chỉnh sửa, tiến hành cập nhật và trả về HttpStatus.OK
        Category updatedCategory = categoryService.updateCategory(updatecategory);
        return ResponseEntity.ok(updatedCategory);
    }
}


//    @PostMapping("/updateStatus/{id}")
//    public ResponseEntity<String> updateOrderStatus(@PathVariable("id") int id, @RequestParam("status") String newStatus) {
//        Category updatedOrder = categoryService.updateOrderStatus(id, newStatus);
//
//        if (updatedOrder != null) {
//            return ResponseEntity.ok("Status updated successfully");
//        } else {
//            return ResponseEntity.notFound().build();
//        }
//    }
    @PostMapping("/updateStatus/{id}")
public ResponseEntity<String> updateOrderStatus(@PathVariable("id") int id, @RequestParam("status") String newStatus) {
    // Kiểm tra xem danh mục có sản phẩm không hoạt động hay không
    boolean hasInactiveProducts = productService.hasInactiveProducts(id);
    
    if (hasInactiveProducts) {
        // Nếu có sản phẩm không hoạt động, không cho phép ẩn danh mục
        return ResponseEntity.badRequest().body("Không thể ẩn danh mục khi còn sản phẩm không hoạt động");
    }
    
    // Tiến hành cập nhật trạng thái danh mục
    Category updatedCategory = categoryService.updateOrderStatus(id, newStatus);

    if (updatedCategory != null) {
        return ResponseEntity.ok("Trạng thái đã được cập nhật thành công");
    } else {
        return ResponseEntity.notFound().build();
    }
}



}
