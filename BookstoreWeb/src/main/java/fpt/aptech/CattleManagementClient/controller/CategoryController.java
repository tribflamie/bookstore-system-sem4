/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.dto.PageDto;
import fpt.aptech.CattleManagementClient.entities.Category;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author admin
 */
@Controller
public class CategoryController {

    private String urlca = "http://localhost:9999/api/category";
    private RestTemplate rest = new RestTemplate();

    @RequestMapping("/category")
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
                ResponseEntity<PageDto<Category>> response = rest.exchange(
                        urlca + "/allcategory?pageNo=" + pageNo,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<PageDto<Category>>() {
                });

                if (response.getStatusCode() == HttpStatus.OK) {
                    PageDto<Category> pageDto = response.getBody();
                    // Lấy danh sách sản phẩm từ API
                    List<Category> categoryList = pageDto.getContent();
                    

                    // Thêm thông tin vào model
                    model.addAttribute("username", username);
                    model.addAttribute("list", categoryList);
                    model.addAttribute("totalPages", pageDto.getTotalPages());
                    model.addAttribute("totalElements", pageDto.getTotalElements());
                    model.addAttribute("currentPage", pageNo);

                    // Calculate page numbers
                    List<Integer> pageNumbers = IntStream.rangeClosed(1, pageDto.getTotalPages()).boxed().collect(Collectors.toList());
                    model.addAttribute("pageNumbers", pageNumbers);

                    return "Admin/category/category";
                } else {
                    // Handle error here
                    return "error";
                }
            default:
                return "redirect:/";
        }
    }

    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            
                model.addAttribute("username", username);
                model.addAttribute("category", new Category());
                return "Admin/category/create";
            default:
                return "redirect:/category";
        }
    }

    @PostMapping("/create")
public String createCategory(@Valid @ModelAttribute Category newCategory,
                             BindingResult bindingResult,
                             RedirectAttributes redirectAttributes) {
    if (bindingResult.hasErrors()) {
        // Nếu dữ liệu nhập vào không hợp lệ, quay lại form với thông báo lỗi
        return "Admin/category/create"; // Quay lại trang form với thông báo lỗi
    }

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);

    HttpEntity<Category> requestEntity = new HttpEntity<>(newCategory, headers);

    try {
        ResponseEntity<Void> responseEntity = rest.exchange(
                urlca + "/Createcategory",
                HttpMethod.POST,
                requestEntity,
                Void.class);

        if (responseEntity.getStatusCode() == HttpStatus.CREATED) {
            redirectAttributes.addFlashAttribute("createSuccess", true);
            return "redirect:/category"; // Trả về trang danh sách sau khi tạo mới thành công
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to create category due to an unexpected error.");
            return "redirect:/create"; // Xử lý trường hợp tạo mới thất bại
        }
    } catch (HttpClientErrorException.Conflict ex) {
        redirectAttributes.addFlashAttribute("errorCategory", true);
        return "redirect:/create"; // Xử lý trường hợp categoryname đã tồn tại
    } catch (Exception ex) {
        redirectAttributes.addFlashAttribute("error", "Failed to create category due to an unexpected error.");
        return "redirect:/create"; // Xử lý các lỗi khác nếu có
    }
}

//    @PostMapping("/create")
//    public String createCategory(Model model,@ModelAttribute Category newCategory, RedirectAttributes redirectAttributes) {
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_JSON);
//
//        HttpEntity<Category> requestEntity = new HttpEntity<>(newCategory, headers);
//
//        try {
//            ResponseEntity<Void> responseEntity = rest.exchange(
//                    urlca + "/Createcategory",
//                    HttpMethod.POST,
//                    requestEntity,
//                    Void.class);
//
//            if (responseEntity.getStatusCode() == HttpStatus.CREATED) {
//                redirectAttributes.addFlashAttribute("createSuccess", true);
//                // Sau khi tạo mới thành công, thêm newCategory vào đầu danh sách
//            
//            
//                return "redirect:/category"; // Trả về trang danh sách sau khi tạo mới thành công
//            } else {
//                redirectAttributes.addFlashAttribute("error", "Failed to create category due to an unexpected error.");
//                return "redirect:/create?categoryname"; // Hoặc có thể điều hướng đến trang xử lý lỗi
//            }
//        } catch (HttpClientErrorException.Conflict ex) {
//            redirectAttributes.addFlashAttribute("error", "Category with the same name already exists.");
//            return "redirect:/create?categoryname"; // Xử lý trường hợp categoryname đã tồn tại
//        } catch (Exception ex) {
//            redirectAttributes.addFlashAttribute("error", "Failed to create category due to an unexpected error.");
//            return "redirect:/create?categoryname"; // Xử lý các lỗi khác nếu có
//        }
//    }
    @GetMapping("/details/{id}")
    public String detailscategory(@PathVariable int id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            case "Employee":
                model.addAttribute("username", username);
                String cateUrlid = urlca + "/" + id;
                Category category = rest.getForObject(cateUrlid, Category.class);
                model.addAttribute("category", category);
                return "Admin/category/details";
            default:
                return "redirect:/";
        }
    }
    @PostMapping("/updateCategoryStatus/{id}")
    public String updateOrderStatus(@PathVariable("id") int id,
            @RequestParam("status") String newStatus,
            RedirectAttributes redirectAttributes) {
        String updateUrl = urlca + "/updateStatus/{id}?status={status}";

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
                redirectAttributes.addFlashAttribute("errorActived", true);
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorActived", true);
        }

        return "redirect:/category" ; // Redirect to order details page
    }

    @GetMapping("/edit/{id}")
    public String editcategory(@PathVariable int id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            
                model.addAttribute("username", username);
                String cateUrl = urlca + "/" + id;
                Category category = rest.getForObject(cateUrl, Category.class);
                model.addAttribute("category", category);
                return "Admin/category/edit";
            default:
                return "redirect:/category";
        }
    }

    @PostMapping("/edit")
    public String updatecategory(@ModelAttribute Category updatedCategory, RedirectAttributes redirectAttributes) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        // Đặt giá trị mặc định cho trường status là "Activated"
    updatedCategory.setStatus("Activated");

        HttpEntity<Category> requestEntity = new HttpEntity<>(updatedCategory, headers);

        try {
            ResponseEntity<Void> responseEntity = rest.exchange(
                    urlca + "/editcategory",
                    HttpMethod.PUT,
                    requestEntity,
                    Void.class);

            if (responseEntity.getStatusCode() == HttpStatus.OK) {
                redirectAttributes.addFlashAttribute("editSuccess", true);
                return "redirect:/category"; // Trả về trang danh sách sau khi cập nhật thành công
            } else {
                redirectAttributes.addFlashAttribute("editError", true);
                return "redirect:/edit/" + updatedCategory.getId(); // Hoặc có thể điều hướng đến trang xử lý lỗi
            }
        } catch (HttpClientErrorException.Conflict ex) {
            redirectAttributes.addFlashAttribute("editError", true);
            return "redirect:/edit/" + updatedCategory.getId(); // Xử lý trường hợp categoryname đã tồn tại
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("editError", true);
            return "redirect:/edit/" + updatedCategory.getId(); // Xử lý các lỗi khác nếu có
        }
    }

//    @PostMapping("/edit")
//    public String updatecategory(@ModelAttribute Category updatedCategory) {
//        String categoryurl = urlca + "/editcategory";
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_JSON);
//
//        HttpEntity<Category> requestEntity = new HttpEntity<>(updatedCategory, headers);
//        ResponseEntity<String> response = rest.exchange(
//                categoryurl,
//                HttpMethod.PUT,
//                requestEntity,
//                String.class
//        );
//
//        if (response.getStatusCode() == HttpStatus.OK) {
//            return "redirect:/category"; // Trả về trang thành công sau khi cập nhật
//        } else {
//            return "Error/errorPage"; // Xử lý lỗi nếu cần
//        }
//    }
    @GetMapping("/delete/{id}")
    public String Delete(@PathVariable int id, Model model) {
        String decategoryurl = urlca + "/" + id;
        try {
            rest.exchange(decategoryurl, HttpMethod.DELETE, null, String.class);
            return "redirect:/category";
        } catch (Exception e) {
            return "Error/errorPage";
        }
    }
}
