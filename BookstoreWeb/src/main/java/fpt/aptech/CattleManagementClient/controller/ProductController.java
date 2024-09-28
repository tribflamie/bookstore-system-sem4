/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.dto.PageDto;
import fpt.aptech.CattleManagementClient.dto.ProductDto;
import fpt.aptech.CattleManagementClient.entities.Category;
import fpt.aptech.CattleManagementClient.entities.Product;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author admin
 */
@Controller
public class ProductController {

    private String urlproduct = "http://localhost:9999/api/product";
    private String urlca = "http://localhost:9999/api/category";
    private RestTemplate rest = new RestTemplate();

    @Value("${upload.path}")
    private String fileUpload;

    @RequestMapping("/product")
    public String function_allFeedback(Model model, HttpSession session, @RequestParam(defaultValue = "1") Integer pageNo) {
        // Truy xuất tên người dùng từ phiên làm việc
        String username = (String) session.getAttribute("username");
        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            case "Employee":
                // Gọi API để lấy danh sách người dùng
                ResponseEntity<PageDto<Product>> response = rest.exchange(
                        urlproduct + "/allproduct?pageNo=" + pageNo,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<PageDto<Product>>() {
                });

                if (response.getStatusCode() == HttpStatus.OK) {
                    PageDto<Product> pageDto = response.getBody();

                    // Thêm thông tin vào model
                    model.addAttribute("username", username);
                    model.addAttribute("list", pageDto.getContent());
                    model.addAttribute("totalPages", pageDto.getTotalPages());
                    model.addAttribute("totalElements", pageDto.getTotalElements());
                    model.addAttribute("currentPage", pageNo);

                    // Calculate page numbers
                    List<Integer> pageNumbers = IntStream.rangeClosed(1, pageDto.getTotalPages()).boxed().collect(Collectors.toList());
                    model.addAttribute("pageNumbers", pageNumbers);

                    return "Admin/product/product";
                } else {
                    // Handle error here
                    return "error";
                }
            default:
                return "redirect:/";
        }
    }

    @PostMapping("/search")
    public String searchByName(Model model, @RequestParam String productname) {
        if (productname == null) {
            model.addAttribute("list", rest.getForObject(urlproduct, List.class));
            return "Admin/product/product";
        } else {
            String productUrl = urlproduct + "/search?productname=" + productname;

            ResponseEntity<List<Product>> responseEntity = rest.exchange(
                    productUrl,
                    HttpMethod.GET,
                    null,
                    new ParameterizedTypeReference<List<Product>>() {
            });

            List<Product> products = responseEntity.getBody();

            model.addAttribute("list", products);

            // Redirect to "/product"
            return "Admin/product/product";
        }
    }

    @GetMapping("/createproduct")
    public String Createproduct(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            
                model.addAttribute("username", username);
                model.addAttribute("product", new Product());

                ResponseEntity<Category[]> responseEntity = rest.getForEntity(urlca, Category[].class);
                Category[] categories = responseEntity.getBody();

                model.addAttribute("category", categories);
                return "Admin/product/createproduct";
            default:
                return "redirect:/product";
        }
    }

    @PostMapping("/createproduct")
    public String Createproduct(@ModelAttribute("productDto") ProductDto newproduct,
            Model model, RedirectAttributes redirectAttributes) {
        MultipartFile file = newproduct.getImage();

        // Kiểm tra xem có file được chọn để upload hay không
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Vui lòng chọn một tập tin để tải lên");
            
        }
        if (newproduct.getProductname().isEmpty() || newproduct.getDate().isEmpty() || newproduct.getQuantity() <= 0 ||
    newproduct.getDescription().isEmpty() || newproduct.getUnits().isEmpty() || newproduct.getPrice() <= 0 ||
    newproduct.getSale() <= 0 || newproduct.getSale() >= newproduct.getPrice()) {

    model.addAttribute("product", new Product());
    ResponseEntity<Category[]> responseEntity = rest.getForEntity(urlca, Category[].class);
    Category[] categories = responseEntity.getBody();
    model.addAttribute("category", categories);

    if (newproduct.getProductname().isEmpty()) {
        
        return "redirect:/createproduct?name";
    } else if (newproduct.getDate().isEmpty()) {
        return "redirect:/createproduct?date";
    } else if (newproduct.getQuantity() <= 0) {
        return "redirect:/createproduct?quantity";
    } else if (newproduct.getDescription().isEmpty()) {
        return "redirect:/createproduct?description";
    } else if (newproduct.getUnits().isEmpty()) {
        return "redirect:/createproduct?units";
    } else if (newproduct.getPrice() <= 0) {
        return "redirect:/createproduct?price";
    } else if (newproduct.getSale() <= 0) {
        return "redirect:/createproduct?sale";
    } else if (newproduct.getSale() >= newproduct.getPrice()) {
        return "redirect:/createproduct?saleprice";
    }
}


        try {
            // Lấy tên file và sao chép vào thư mục upload
            String fileName = file.getOriginalFilename();
            FileCopyUtils.copy(newproduct.getImage().getBytes(), new File(fileUpload, fileName));

            // Tạo đối tượng Product từ ProductDto
            Product product = new Product();
            product.setId(newproduct.getId());
            product.setProductname(newproduct.getProductname());
            product.setSale(newproduct.getSale());
            product.setImage(fileName);
            product.setDate(newproduct.getDate());
            product.setPrice(newproduct.getPrice());
            product.setQuantity(newproduct.getQuantity());
            product.setUnits(newproduct.getUnits());
            product.setDescription(newproduct.getDescription());
            product.setStatus(newproduct.getStatus());
             product.setActive(newproduct.getActive());
            product.setCategoryid(newproduct.getCategoryid());

            // Gọi REST API để tạo sản phẩm mới
            ResponseEntity<String> response = rest.postForEntity(urlproduct + "/createproduct", product, String.class);

            // Xử lý phản hồi từ REST API
            if (response.getStatusCode() == HttpStatus.CREATED) {
                redirectAttributes.addFlashAttribute("createSuccess", true);
                return "redirect:/product";
            } else {
                redirectAttributes.addFlashAttribute("productname", true);
                return "redirect:/createproduct?productname";
            }

        } catch (HttpClientErrorException.Conflict ex) {
            redirectAttributes.addFlashAttribute("error", "Category with the same name already exists.");
            return "redirect:/createproduct?productname"; // Xử lý trường hợp categoryname đã tồn tại
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Failed to create category due to an unexpected error.");
            return "redirect:/createproduct?productname"; // Xử lý các lỗi khác nếu có
        }
    }

//    @PostMapping("/createproduct")
//    public String Createproduct(@ModelAttribute("productDto") ProductDto newproduct,
//            Model model, RedirectAttributes redirectAttributes) throws IOException {
//        MultipartFile file = newproduct.getImage();
//        if (file.isEmpty()) {
//            return "Please select a file to upload";
//        }
//
//        try {
//            String fileName = file.getOriginalFilename();
//            FileCopyUtils.copy(newproduct.getImage().getBytes(), new File(fileUpload, fileName));
//
//            Product product = new Product();
//            product.setId(newproduct.getId());
//            product.setProductname(newproduct.getProductname());
//            product.setSale(newproduct.getSale());
//            product.setImage(fileName);
//            product.setDate(newproduct.getDate());
//            product.setPrice(newproduct.getPrice());
//            product.setQuantity(newproduct.getQuantity());
//            product.setUnits(newproduct.getUnits());
//            product.setDescription(newproduct.getDescription());
//            product.setStatus(newproduct.getStatus());
//            product.setCategoryid(newproduct.getCategoryid());
//
//            // ... xử lý các thông tin khác và lưu vào cơ sở dữ liệu
//            String createUrl = urlproduct + "/createproduct"; // Endpoint của RESTful API để tạo đối tượng mới
//            rest.postForEntity(createUrl, product, Product.class);
//            return "redirect:/product";
//        } catch (IOException e) {
//            return "Failed to upload file: " + e.getMessage();
//        }
//
//    }
    @GetMapping("/detailsproduct/{id}")
    public String detailsproduct(@PathVariable int id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            case "Employee":
                model.addAttribute("username", username);
                String productUrl = urlproduct + "/" + id;
                Product product = rest.getForObject(productUrl, Product.class);
                model.addAttribute("product", product);

                return "Admin/product/detailsproduct";
            default:
                return "redirect:/";
        }
    }

    @GetMapping("/editproduct/{id}")
    public String editproduct(@PathVariable int id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            
                model.addAttribute("username", username);
                String productUrl = urlproduct + "/" + id;
                Product product = rest.getForObject(productUrl, Product.class);
                model.addAttribute("product", product);

                ResponseEntity<Category[]> responseEntity = rest.getForEntity(urlca, Category[].class);
                Category[] categories = responseEntity.getBody();
                model.addAttribute("category", categories);

                return "Admin/product/editproduct";
            default:
                return "redirect:/product";
        }
    }

  @PostMapping("/editproduct/{id}")
public String Editproduct(@ModelAttribute("productDto") ProductDto product, @PathVariable int id,
        Model model, RedirectAttributes redirectAttributes) throws IOException {
    try {
        String productUrl = urlproduct + "/" + id;
        Product existingProduct = rest.getForObject(productUrl, Product.class);
        // Kiểm tra không cho phép các trường thông tin sản phẩm trống
        if (product.getProductname().isEmpty() || 
            
            product.getQuantity() == null || 
            product.getSale() == null || 
            product.getCategoryid() == null || 
            product.getDate() == null || 
            product.getUnits().isEmpty() || 
            product.getDescription().isEmpty() || 
            product.getStatus().isEmpty() || 
            product.getActive() == null) {
            
            redirectAttributes.addFlashAttribute("EmptyFieldError", true);
            return "redirect:/editproduct/" + id;
        }
        // Validate price and sale
        if (product.getPrice() < 0) {
            redirectAttributes.addFlashAttribute("PriceError", true);
            return "redirect:/editproduct/" + id;
        }
        if (product.getSale() < 0) {
            redirectAttributes.addFlashAttribute("SaleError", true);
            return "redirect:/editproduct/" + id;
        }
        if (product.getQuantity() < 0) {
            redirectAttributes.addFlashAttribute("QuantityError", true);
            return "redirect:/editproduct/" + id;
        }
        
        if (product.getSale() >= product.getPrice()) {
            redirectAttributes.addFlashAttribute("PriceSaleError", true);
            return "redirect:/editproduct/" + id;
        }

        MultipartFile file = product.getImage();
        if (file != null && !file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            FileCopyUtils.copy(file.getBytes(), new File(fileUpload, fileName));

            // Cập nhật thông tin sản phẩm với hình ảnh mới
            existingProduct.setProductname(product.getProductname());
            existingProduct.setPrice(product.getPrice());
            existingProduct.setQuantity(product.getQuantity());
            existingProduct.setImage(fileName);
            existingProduct.setCategoryid(product.getCategoryid());
            existingProduct.setSale(product.getSale());
            existingProduct.setDate(product.getDate());
            existingProduct.setUnits(product.getUnits());
            existingProduct.setDescription(product.getDescription());
            existingProduct.setStatus(product.getStatus());
            existingProduct.setActive(product.getActive());
        } else {
            // Không có tệp tin mới, giữ nguyên hình ảnh cũ
            existingProduct.setProductname(product.getProductname());
            existingProduct.setPrice(product.getPrice());
            existingProduct.setQuantity(product.getQuantity());
            existingProduct.setCategoryid(product.getCategoryid());
            existingProduct.setSale(product.getSale());
            existingProduct.setDate(product.getDate());
            existingProduct.setUnits(product.getUnits());
            existingProduct.setDescription(product.getDescription());
            existingProduct.setStatus(product.getStatus());
            existingProduct.setActive(product.getActive());
        }

        // Gọi REST API để cập nhật sản phẩm
        String updateUrl = urlproduct + "/editproduct";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Product> requestEntity = new HttpEntity<>(existingProduct, headers);
        ResponseEntity<Void> responseEntity = rest.exchange(
                updateUrl,
                HttpMethod.PUT,
                requestEntity,
                Void.class
        );

        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            redirectAttributes.addFlashAttribute("editSuccess", true);
            return "redirect:/product"; // Chuyển hướng về trang sản phẩm sau khi cập nhật thành công
        } else {
            redirectAttributes.addFlashAttribute("editError", true);
            return "redirect:/editproduct/" + id; // Xử lý lỗi nếu không thành công
        }
    } catch (HttpClientErrorException.Conflict ex) {
        redirectAttributes.addFlashAttribute("editError", true);
        return "redirect:/editproduct/" + id; // Xử lý trường hợp lỗi conflict (ví dụ: categoryname đã tồn tại)
    } catch (Exception ex) {
        redirectAttributes.addFlashAttribute("editError", true);
        return "redirect:/editproduct/" + id; // Xử lý các lỗi khác nếu có
    }
}


    @GetMapping("/deleteproduct/{id}")
    public String Delete(@PathVariable int id, Model model) {
        String producturl = urlproduct + "/" + id;
        try {
            rest.exchange(producturl, HttpMethod.DELETE, null, String.class);
            return "redirect:/product";
        } catch (Exception e) {
            return "Error/errorPage";
        }
    }
    @PostMapping("/updateProductStatus/{id}")
    public String updateOrderStatus(@PathVariable("id") int id,
            @RequestParam("active") String newStatus,
            RedirectAttributes redirectAttributes) {
        String updateUrl = urlproduct + "/updateStatus/{id}?active={active}";

        // Prepare HTTP headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Create HTTP entity with updated status
        HttpEntity<String> requestEntity = new HttpEntity<>(headers);

        try {
            // Send POST request to update status
            ResponseEntity<String> response = rest.exchange(
                    updateUrl,
                    HttpMethod.POST,
                    requestEntity,
                    String.class,
                    id,
                    newStatus
            );

            // Check response status
            if (response.getStatusCode() == HttpStatus.OK) {
                redirectAttributes.addFlashAttribute("Activated",true);
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to update status");
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error: " + ex.getMessage());
        }

        return "redirect:/product" ; // Redirect to order details page
    }

}
