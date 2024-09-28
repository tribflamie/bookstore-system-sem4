/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;

import fpt.aptech.CattleManagement.dto.PageDto;
import fpt.aptech.CattleManagement.entities.Category;
import fpt.aptech.CattleManagement.entities.Product;
import fpt.aptech.CattleManagement.entities.User;
import fpt.aptech.CattleManagement.service.CategoryService;
import fpt.aptech.CattleManagement.service.ProductService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 *
 * @author admin
 */
@RestController
@RequestMapping("/api/product")
public class ProductController {

    @Autowired
    ProductService productService;
    @Autowired
    CategoryService categoryService;

    @GetMapping()
    @ResponseStatus(HttpStatus.OK)
    public List<Product> findallproduct() {
        return productService.FindAll();
    }
     @GetMapping("/allproduct")
    public PageDto<Product> getAllFeedback(
            @RequestParam(defaultValue = "1") int pageNo
            ) {
        Page<Product> feedbackPage = productService.getAll(pageNo);

        PageDto<Product> pageDto = new PageDto<>();
        pageDto.setContent(feedbackPage.getContent());
        pageDto.setTotalPages(feedbackPage.getTotalPages());

        return pageDto;
    }
    

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Product ProductbyId(@PathVariable int id) {
        
        return productService.productbyId(id);
    }
     @GetMapping("/countproduct")
    @ResponseStatus(HttpStatus.OK)
    public long getCountOfRecords() {
        long count = productService.countProduct();
        return count;
    }

    @GetMapping("/search")
    public List<Product> searchProductsByName(@RequestParam String productname) {
        return productService.searchByName(productname);
    }

    @GetMapping("/searchprice")
    public List<Product> searchProductsByPriceRange(
            @RequestParam(name = "min") double minPrice,
            @RequestParam(name = "max") double maxPrice
    ) {
        return productService.findByPrice(minPrice, maxPrice);
    }

    @GetMapping("/bycategory")
    public List<Product> getProductsByCategory(@RequestParam("categoryid") Integer categoryid) {
        Category category = new Category();
        category.setId(categoryid);
        List<Product> products = productService.findByIdCats(category);
        return products;
    }

//    @PostMapping("/createproduct")
//    @ResponseStatus(HttpStatus.CREATED)
//    public void saveproduct(@Validated @RequestBody Product newproduct) {
//        User user = new User();
//        user.setId(1);
//        newproduct.setUserId(user);
//
//        productService.saveproduct(newproduct);
//    }
    @PostMapping("/createproduct")
@ResponseStatus(HttpStatus.CREATED)
public ResponseEntity<String> saveproduct(@Validated @RequestBody Product newproduct) {
    // Kiểm tra xem productname đã tồn tại chưa
    // if (productService.existsByProductname(newproduct.getProductname())) {
    //     return ResponseEntity.status(HttpStatus.CONFLICT).build();
    // }

    // Lấy thông tin của người dùng và gán vào Product
    User user = new User();
    user.setId(1);
    newproduct.setUserId(user);

    // Lưu Product vào cơ sở dữ liệu
    productService.saveproduct(newproduct);

    return ResponseEntity.status(HttpStatus.CREATED).body("Product created successfully.");
}


    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteproduct(@PathVariable int id) {
        productService.deleteproduct(id);
    }
    @PutMapping("/editproduct")
@ResponseStatus(HttpStatus.OK)
public ResponseEntity<Product> editcategory(@RequestBody Product updateproduct) {
    // Lấy thông tin sản phẩm hiện tại từ cơ sở dữ liệu
    Product existingProduct = productService.productbyId(updateproduct.getId());

    // Kiểm tra xem có thay đổi tên sản phẩm hay không
    if (!existingProduct.getProductname().equals(updateproduct.getProductname())) {
        // Nếu có thay đổi tên sản phẩm, kiểm tra xem tên mới đã tồn tại trong cơ sở dữ liệu chưa
        boolean exists = productService.existsByProductname(updateproduct.getProductname());

        if (exists) {
            // Nếu tên mới đã tồn tại, trả về lỗi HttpStatus.CONFLICT
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
    }

    // Nếu không có thay đổi tên hoặc tên mới chưa tồn tại, tiến hành cập nhật thông tin sản phẩm và trả về HttpStatus.OK
    Product updatedProduct = productService.updateProduct(updateproduct);
    return ResponseEntity.ok(updatedProduct);
}

    @PostMapping("/updateStatus/{id}")
    public ResponseEntity<String> updateOrderStatus(@PathVariable("id") int id, @RequestParam("active") String newActive) {
        Product updatedOrder = productService.updateOrderStatus(id, newActive);

        if (updatedOrder != null) {
            return ResponseEntity.ok("Status updated successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

//    @PutMapping("/editproduct")
//    @ResponseStatus(HttpStatus.CREATED)
//    public void editproduct(@Validated @RequestBody Product newproduct) {
//        User user = new User();
//        user.setId(1);
//
//        newproduct.setUserId(user);
//
//        productService.saveproduct(newproduct);
//    }
//    @PutMapping("/editproduct")
//@ResponseStatus(HttpStatus.CREATED)
//public ResponseEntity<String> editproduct(@Validated @RequestBody Product newproduct) {
//    // Kiểm tra xem productname đã tồn tại chưa (trừ trường hợp sửa chính nó)
//    Product existingProduct = productService.findbyId(newproduct.getId()); // Giả sử có hàm này để tìm Product bằng ID
//
//    if (!existingProduct.getProductname().equals(newproduct.getProductname()) &&
//            productService.existsByProductname(newproduct.getProductname())) {
//        return ResponseEntity.status(HttpStatus.CONFLICT).body("Product with name " + newproduct.getProductname() + " already exists.");
//    }
//
//    // Gán thông tin của người dùng và lưu Product
//    User user = new User();
//    user.setId(1);
//    newproduct.setUserId(user);
//
//    // Lưu Product vào cơ sở dữ liệu
//    productService.saveproduct(newproduct);
//
//    return ResponseEntity.status(HttpStatus.CREATED).body("Product edited successfully.");
//}

}
