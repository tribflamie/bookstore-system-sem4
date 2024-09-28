/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.dto.BlogDto;
import fpt.aptech.CattleManagementClient.dto.PageDto;
import fpt.aptech.CattleManagementClient.entities.Blog;
import fpt.aptech.CattleManagementClient.entities.Productcart;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.io.File;
import java.io.IOException;
import java.util.Date;
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
import org.springframework.validation.BindingResult;
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
public class BlogController {

    private String urlblog = "http://localhost:9999/api/blog";
    private String urlproductcart = "http://localhost:9999/api/productcart";
    private String urlproduct = "http://localhost:9999/api/product";
    private RestTemplate rest = new RestTemplate();

    @Value("${upload.path}")
    private String fileUpload;

    @GetMapping("/blog")
    public String page(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("lblog", rest.getForObject(urlblog, List.class));
        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
        }
        );
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username == null) {
                return "Admin/blog/blog";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                    totalAmount += productcart.getSubtotal();
                }
            }
        }
        model.addAttribute("totlal", totalAmount);
        return "Admin/blog/blog";
    }
    @RequestMapping("/listblog")
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
                ResponseEntity<PageDto<Blog>> response = rest.exchange(
                        urlblog + "/allblog?pageNo=" + pageNo,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<PageDto<Blog>>() {
                });

                if (response.getStatusCode() == HttpStatus.OK) {
                    PageDto<Blog> pageDto = response.getBody();
                    // Lấy danh sách sản phẩm từ API
                    List<Blog> categoryList = pageDto.getContent();
                    

                    // Thêm thông tin vào model
                    model.addAttribute("username", username);
                    model.addAttribute("listblog", categoryList);
                    model.addAttribute("totalPages", pageDto.getTotalPages());
                    model.addAttribute("totalElements", pageDto.getTotalElements());
                    model.addAttribute("currentPage", pageNo);

                    // Calculate page numbers
                    List<Integer> pageNumbers = IntStream.rangeClosed(1, pageDto.getTotalPages()).boxed().collect(Collectors.toList());
                    model.addAttribute("pageNumbers", pageNumbers);

                    return "Admin/blog/listblog";
                } else {
                    // Handle error here
                    return "error";
                }
            default:
                return "redirect:/";
        }
    }


    
    @GetMapping("/createblog")
public String showCreateForm(Model model, HttpSession session) {
    String username = (String) session.getAttribute("username");
    
    if (username == null) {
        return "redirect:/login";
    }
    
    // Kiểm tra vai trò của người dùng
    switch (username) {
        case "Admin":
        
            model.addAttribute("username", username);
            model.addAttribute("blog", new Blog());
            return "Admin/blog/createblog";
        default:
            return "redirect:/listblog";
    }
}


@PostMapping("/createblog")
public String createblog(@ModelAttribute("blog") Blog blog,
        @Valid BindingResult result, Model model,
        @RequestParam("file") MultipartFile file,
        RedirectAttributes redirectAttributes) throws IOException {
    if (result.hasErrors()) {
        return "Admin/blog/createblog";
    }

    String fileName = file.getOriginalFilename();
    String filePath = fileUpload + "/" + fileName;
    File dest = new File(filePath);

    // Create directories if they do not exist
    if (!dest.getParentFile().exists()) {
        dest.getParentFile().mkdirs();
    }

    try {
        FileCopyUtils.copy(file.getBytes(), dest);
    } catch (IOException e) {
        redirectAttributes.addFlashAttribute("errorblog", "File upload failed!");
        return "redirect:/createblog";
    }

    Date date = new Date();
    blog.setImage(fileName);
    blog.setDate(date.toString());

    try {
        String createUrl = urlblog + "/createblog"; // RESTful API endpoint
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Blog> requestEntity = new HttpEntity<>(blog, headers);
        ResponseEntity<String> response = rest.exchange(
                createUrl,
                HttpMethod.POST,
                requestEntity,
                String.class
        );

        if (response.getStatusCode() == HttpStatus.CREATED) {
            redirectAttributes.addFlashAttribute("successblog", true);
            return "redirect:/listblog"; // Success page
        } else {
            redirectAttributes.addFlashAttribute("errorblog", true);
            return "redirect:/createblog?blogname"; // Handle failure
        }
    } catch (HttpClientErrorException.Conflict ex) {
        redirectAttributes.addFlashAttribute("errorblog", true);
        return "redirect:/createblog?blogname"; // Handle conflict error
    } catch (Exception ex) {
        redirectAttributes.addFlashAttribute("errorblog", true);
        return "redirect:/createblog?blogname"; // Handle other exceptions
    }
}

    @GetMapping("/detailsblog/{id}")
public String detailsblog(@PathVariable int id, Model model, HttpSession session) {
    String username = (String) session.getAttribute("username");
    
    if (username == null) {
        return "redirect:/login";
    }
    
    // Kiểm tra vai trò của người dùng
    switch (username) {
        case "Admin":
        case "Employee":
            model.addAttribute("username", username);
            String cateUrlid = urlblog + "/" + id;
            Blog blog = rest.getForObject(cateUrlid, Blog.class);
            model.addAttribute("blog", blog);
            return "Admin/blog/detailsblog";
        default:
            return "redirect:/";
    }
}


    @GetMapping("/deleteblog/{id}")
    public String Deleteblog(@PathVariable int id, Model model) {
        String deblogurl = urlblog + "/" + id;
        try {
            rest.exchange(deblogurl, HttpMethod.DELETE, null, String.class);
            return "redirect:/listblog";
        } catch (Exception e) {
            return "Error/errorPage";
        }
    }

    @GetMapping("/editblog/{id}")
public String editblog(@PathVariable int id, Model model, HttpSession session) {
    String username = (String) session.getAttribute("username");
    
    if (username == null) {
        return "redirect:/login";
    }
    
    // Kiểm tra vai trò của người dùng
    switch (username) {
        case "Admin":
        
            model.addAttribute("username", username);
            String blogUrl = urlblog + "/" + id;
            Blog blog = rest.getForObject(blogUrl, Blog.class);
            model.addAttribute("blog", blog);
            return "Admin/blog/editblog";
        default:
            return "redirect:/listblog";
    }
}
 @PostMapping("/editblog/{id}")
public String Editproduct( @ModelAttribute("blogDto") BlogDto product, @PathVariable int id,
        Model model, RedirectAttributes redirectAttributes) throws IOException {
    
    try {
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("NameError", true);
            return "redirect:/editblog/" + id;
        }
        if (product.getDescription() == null || product.getDescription().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("DesError", true);
            return "redirect:/editblog/" + id;
        }
        if (product.getContent() == null || product.getContent().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("ContentError", true);
            return "redirect:/editblog/" + id;
        }
        
        String productUrl = urlblog + "/" + id;
        Blog existingProduct = rest.getForObject(productUrl, Blog.class);

        MultipartFile file = product.getImage();
        if (file != null && !file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            FileCopyUtils.copy(file.getBytes(), new File(fileUpload, fileName));

            // Cập nhật thông tin sản phẩm với hình ảnh mới
            existingProduct.setName(product.getName());
            existingProduct.setActive(product.getActive());
            existingProduct.setContent(product.getContent());
            existingProduct.setImage(fileName);         
            existingProduct.setDescription(product.getDescription());
            existingProduct.setDate(product.getDate());          
            existingProduct.setStatus(product.getStatus());
        } else {
            // Không có tệp tin mới, giữ nguyên hình ảnh cũ
            existingProduct.setName(product.getName());
            existingProduct.setActive(product.getActive());
            existingProduct.setContent(product.getContent());                    
            existingProduct.setDescription(product.getDescription());
            existingProduct.setDate(product.getDate());          
            existingProduct.setStatus(product.getStatus());
        }

        // Gọi REST API để cập nhật sản phẩm
        String updateUrl = urlblog + "/editblog";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Blog> requestEntity = new HttpEntity<>(existingProduct, headers);
        ResponseEntity<Void> responseEntity = rest.exchange(
                updateUrl,
                HttpMethod.PUT,
                requestEntity,
                Void.class
        );

        if (responseEntity.getStatusCode() == HttpStatus.OK) {
            redirectAttributes.addFlashAttribute("editSuccess", true);
            return "redirect:/listblog"; // Chuyển hướng về trang sản phẩm sau khi cập nhật thành công
        } else {
            redirectAttributes.addFlashAttribute("editError", true);
            return "redirect:/editblog/" + id; // Xử lý lỗi nếu không thành công
        }
    } catch (HttpClientErrorException.Conflict ex) {
        redirectAttributes.addFlashAttribute("editError", true);
        return "redirect:/editblog/" + id; // Xử lý trường hợp lỗi conflict (ví dụ: categoryname đã tồn tại)
    } catch (Exception ex) {
        redirectAttributes.addFlashAttribute("editError", true);
        return "redirect:/editblog/" + id; // Xử lý các lỗi khác nếu có
    }
}


//    @PostMapping("/editcattle/{id}")
//public String editblog(@ModelAttribute("blog") Blog blog,
//        @Valid BindingResult result, Model model,
//        @RequestParam("file") MultipartFile file,
//        RedirectAttributes redirectAttributes) throws IOException {
//
//    if (result.hasErrors()) {
//        return "Admin/blog/editblog"; // Trả về trang chỉnh sửa nếu có lỗi
//    }
//
//    Date date = new Date();
//    String fileName = null;
//
//    // Kiểm tra nếu có tệp ảnh mới
//    if (file != null && !file.isEmpty()) {
//        fileName = file.getOriginalFilename();
//        String filePath = fileUpload + "/" + fileName;
//        File dest = new File(filePath);
//        FileCopyUtils.copy(file.getBytes(), dest);
//    } else {
//        // Nếu không có tệp ảnh mới, giữ nguyên hình ảnh cũ
//        fileName = blog.getImage();
//    }
//
//    blog.setImage(fileName);
//    blog.setDate(date.toString());
//
//    try {
//        String createUrl = urlblog + "/editblog"; // Endpoint của RESTful API để cập nhật đối tượng
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_JSON);
//
//        HttpEntity<Blog> requestEntity = new HttpEntity<>(blog, headers);
//        ResponseEntity<String> response = rest.exchange(
//                createUrl,
//                HttpMethod.PUT,
//                requestEntity,
//                String.class
//        );
//
//        if (response.getStatusCode() == HttpStatus.OK) {
//            return "redirect:/listblog"; // Chuyển hướng đến danh sách blog sau khi cập nhật thành công
//        } else {
//            return "Error/errorPage"; // Xử lý lỗi nếu cần
//        }
//    } catch (Exception e) {
//        e.printStackTrace(); // Ghi lỗi vào log
//    }
//    return "redirect:/listblog"; // Chuyển hướng đến danh sách blog nếu có lỗi
//}

    @GetMapping("/detailblog/{id}")
    public String detailsclientblog(@PathVariable int id, Model model, HttpSession session) {
        double totalAmount = 0.0;

        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
        String cateUrlid = urlblog + "/" + id;
        Blog blog = rest.getForObject(cateUrlid, Blog.class);
        model.addAttribute("blog", blog);
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
        }
        );
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username == null) {
                return "Admin/blog/detailblog";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                    totalAmount += productcart.getSubtotal();
                }
            }
        }
        model.addAttribute("totlal", totalAmount);

        return "Admin/blog/detailblog";
    }
    
    @PostMapping("/updateBlogStatus/{id}")
    public String updateOrderStatus(@PathVariable("id") int id,
            @RequestParam("active") String newStatus,
            RedirectAttributes redirectAttributes) {
        String updateUrl = urlblog + "/updateStatus/{id}?active={active}";

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

        return "redirect:/listblog" ; // Redirect to order details page
    }
}
