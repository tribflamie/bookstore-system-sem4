/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.dto.PageDto;
import fpt.aptech.CattleManagementClient.dto.SignUpDto;
import fpt.aptech.CattleManagementClient.entities.Orders;
import fpt.aptech.CattleManagementClient.entities.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
public class AuthController {

    private String url = "http://localhost:9999/api/auth";
    private String urlorders = "http://localhost:9999/api/orders";

    private RestTemplate rest = new RestTemplate();

    @RequestMapping("/listuser")
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
                ResponseEntity<PageDto<User>> response = rest.exchange(
                        url + "/alluser?pageNo=" + pageNo,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<PageDto<User>>() {
                });

                if (response.getStatusCode() == HttpStatus.OK) {
                    PageDto<User> pageDto = response.getBody();

                    // Thêm thông tin vào model
                    model.addAttribute("username", username);
                    model.addAttribute("list", pageDto.getContent());
                    model.addAttribute("totalPages", pageDto.getTotalPages());
                    model.addAttribute("totalElements", pageDto.getTotalElements());
                    model.addAttribute("currentPage", pageNo);

                    // Calculate page numbers
                    List<Integer> pageNumbers = IntStream.rangeClosed(1, pageDto.getTotalPages()).boxed().collect(Collectors.toList());
                    model.addAttribute("pageNumbers", pageNumbers);

                    return "Auth/index";
                } else {
                    // Handle error here
                    return "error";
                }
            default:
                return "redirect:/";
        }
    }

    @RequestMapping("/login")
    public String login(Model model) {
        model.addAttribute("login", new User());

        return "Auth/login";
    }

//    @PostMapping("/login")
//    public String login(Model model, @ModelAttribute("user") User user, HttpSession session, RedirectAttributes redirectAttributes) {
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_JSON);
//        HttpEntity<User> request = new HttpEntity<>(user, headers);
//
//        try {
//            ResponseEntity<User> response = rest.exchange(
//                    url + "/login",
//                    HttpMethod.POST,
//                    request,
//                    User.class);
//
//            if (response.getStatusCode() == HttpStatus.ACCEPTED || response.getStatusCode() == HttpStatus.OK) {
//                User loggedInUser = response.getBody();
//
//                session.setAttribute("username", loggedInUser.getRole());
//                session.setAttribute("user", loggedInUser.getId());
//
//                // Xử lý dựa trên vai trò của người dùng
//                switch (loggedInUser.getRole()) {
//                    case "Admin":
//
//                        return "redirect:/admin";
//
//                    case "Employee":
//
//                        return "redirect:/listuser";
//                    case "User":
//                        session.setAttribute("username", loggedInUser.getUsername());
//                        return "redirect:/";
//                    default:
//                        model.addAttribute("error", "Unknown role");
//                        return "redirect:/login";
//                }
//            } else {
//                model.addAttribute("error", "Login failed");
//                return "redirect:/login";
//            }
//        } catch (Exception ex) {
//            // Xử lý lỗi từ API đăng nhập
//            redirectAttributes.addFlashAttribute("error", "Error during login: " + ex.getMessage());
//            return "redirect:/login";
//        }
//    }
    @PostMapping("/login")
    public String login(Model model, @ModelAttribute("user") User user, HttpSession session, RedirectAttributes redirectAttributes) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<User> request = new HttpEntity<>(user, headers);

        try {
            ResponseEntity<User> response = rest.exchange(
                    url + "/login",
                    HttpMethod.POST,
                    request,
                    User.class);

            if (response.getStatusCode() == HttpStatus.ACCEPTED || response.getStatusCode() == HttpStatus.OK) {
                User loggedInUser = response.getBody();

                // Kiểm tra trạng thái của người dùng
                if (!"Activated".equals(loggedInUser.getStatus())) {
                    model.addAttribute("error", "User is not activated");
                    return "redirect:/login";
                }

                session.setAttribute("username", loggedInUser.getRole());
                session.setAttribute("user", loggedInUser.getId());

                // Xử lý dựa trên vai trò của người dùng
                switch (loggedInUser.getRole()) {
                    case "Admin":
                        return "redirect:/product";
                    case "Employee":
                        return "redirect:/listuser";
                    case "User":
                        session.setAttribute("username", loggedInUser.getUsername());
                        redirectAttributes.addFlashAttribute("errorMessageLogin", true);
                        return "redirect:/";
                    default:
                        model.addAttribute("error", "Unknown role");
                        return "redirect:/login";
                }
            } else {
                model.addAttribute("error", "Login failed");
                return "redirect:/login";
            }
        } catch (Exception ex) {
            // Xử lý lỗi từ API đăng nhập
            redirectAttributes.addFlashAttribute("error", "Error during login: " + ex.getMessage());
            return "redirect:/login";
        }
    }

    @GetMapping("/register")
    public String register(Model model) {
//        SignUpDto user = new SignUpDto();
        model.addAttribute("signupDto", new SignUpDto());
        return "Auth/register";
    }

    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("signupDto") SignUpDto signUpDto,
            Model model, RedirectAttributes redirectAttributes, HttpSession session) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<SignUpDto> request = new HttpEntity<>(signUpDto, headers);
        try {
            ResponseEntity<String> response = rest.exchange(
                    url + "/register",
                    HttpMethod.POST,
                    request,
                    String.class);
            if (response.getStatusCode() == HttpStatus.OK) {
                // Đăng nhập thành công, chuyển hướng đến trang index.html
                redirectAttributes.addFlashAttribute("successuser", true);
                String username = (String) session.getAttribute("username");
                // Thêm tên người dùng vào mô hình
                model.addAttribute("username", username);
                return "redirect:/login";
            } else if (response.getStatusCode() == HttpStatus.FOUND) {
                redirectAttributes.addFlashAttribute("error", "Email already exists");
                return "redirect:/register";
            } else {
                redirectAttributes.addFlashAttribute("name", "register failed");
                return "redirect:/register";
            }
        } catch (Exception ex) {
            // Xử lý lỗi từ API đăng nhập
            redirectAttributes.addFlashAttribute("name", "Error during login: " + ex.getMessage());
            return "redirect:/register";
        }
    }

    @GetMapping("/logout")

   public String logout(HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        // Invalidate the session to log the user out
      session.invalidate();
        return "redirect:/";
    }

//    @GetMapping("/logout")
//    public String logout(HttpServletRequest request, RedirectAttributes redirectAttributes) {
//        HttpSession session = request.getSession(false);
//        if (session != null) {
//            String status = (String) session.getAttribute("status");
//            if ("Not Activated".equals(status)) {
//                // Invalidating session
//                session.invalidate();
//                redirectAttributes.addFlashAttribute("logoutMessage", "Logged out successfully due to account status being 'Not Activated'");
//                return "redirect:/";
//            } else {
//                redirectAttributes.addFlashAttribute("logoutMessage", "No need to logout, account status is active");
//                return "redirect:/";
//            }
//        } else {
//            redirectAttributes.addFlashAttribute("logoutMessage", "No active session found");
//            return "redirect:/";
//        }
//    }

    @GetMapping("/createuser")
    public String showCreateForm(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
                model.addAttribute("username", username);
                model.addAttribute("user", new User());
                return "Auth/create";
            default:
                redirectAttributes.addFlashAttribute("errorMessageNotAdmin", true);
                return "redirect:/listuser";
        }
    }

    @PostMapping("/createuser")
    public String createUser(@Valid @ModelAttribute("user") User newUser, BindingResult bindingResult,
            RedirectAttributes redirectAttributes, Model model, HttpSession session) {
        if (bindingResult.hasErrors()) {
            // Nếu dữ liệu nhập vào không hợp lệ, redirect lại form với thông báo lỗi
            return "Auth/create"; // Quay lại trang form với thông báo lỗi
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<User> request = new HttpEntity<>(newUser, headers);

        try {
            // Gọi API RestController để tạo mới người dùng
            ResponseEntity<User> response = rest.exchange(
                    url + "/create",
                    HttpMethod.POST,
                    request,
                    User.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                // Người dùng được tạo thành công, chuyển hướng đến trang danh sách người dùng
                redirectAttributes.addFlashAttribute("successUser", true);
                return "redirect:/listuser";
            } else {
                redirectAttributes.addFlashAttribute("emailero", true);
                return "redirect:/createuser?email";
            }
        } catch (HttpClientErrorException.Conflict ex) {
            redirectAttributes.addFlashAttribute("emailero", true);
            return "redirect:/createuser?email"; // Xử lý trường hợp categoryname đã tồn tại
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("emailero", true);
            return "redirect:/createuser?email"; // Xử lý các lỗi khác nếu có
        }

    }

//    @PostMapping("/createuser")
//    public String createObject(@ModelAttribute("user") User newObject, RedirectAttributes redirectAttributes) {
//        try {
//            // Gửi yêu cầu POST đến API để tạo mới người dùng
//        ResponseEntity<User> response = rest.postForEntity(url + "/create", newObject, User.class);
//        if (response.getStatusCode() == HttpStatus.OK) {
//            // Người dùng được tạo thành công, chuyển hướng đến trang danh sách người dùng
//            User createUser = response.getBody();
//            return "redirect:/listuser";
//        } else if (response.getStatusCode() == HttpStatus.FOUND) {
//            
//            return "redirect:/createuser?email";
//        }
//        } catch (Exception ex) {
//        }
//
//
//        return "redirect:/createuser?email";
//        
//    }
    @GetMapping("/userdetails/{id}")
    public String getUserDetails(Model model, @PathVariable int id, RedirectAttributes redirectAttributes, HttpSession session) {
        try {
            // Check if user is logged in
            String username = (String) session.getAttribute("username");
            model.addAttribute("username", username);
            if (username == null) {
                return "redirect:/login";
            }

            // Fetch user details
            ResponseEntity<User> response = rest.getForEntity(url + "/userdetails/" + id, User.class);
            if (response.getStatusCode() == HttpStatus.OK) {
                User user = response.getBody();
                model.addAttribute("user", user);

                // Fetch orders
                ResponseEntity<List<Orders>> ordersResponse = rest.exchange(
                        urlorders,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<List<Orders>>() {
                }
                );
                List<Orders> orders = ordersResponse.getBody();
                model.addAttribute("orders", orders);

                return "Auth/details"; // Return the details view with user and orders
            } else {
                redirectAttributes.addFlashAttribute("error", "User details not found");
                return "redirect:/"; // Redirect to user list if user not found
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error fetching user details: " + ex.getMessage());
            return "redirect:/"; // Redirect to user list on error
        }
    }
// Hiển thị form chỉnh sửa người dùng

    @GetMapping("/edituser/{id}")
    public String showEditForm(Model model, @PathVariable int id, HttpSession session, RedirectAttributes redirectAttributes) {
        // Kiểm tra phiên đăng nhập
        String username = (String) session.getAttribute("username");
        if (username == null) {
            return "redirect:/login";
        }

        // Gọi API để lấy thông tin người dùng cần chỉnh sửa
        ResponseEntity<User> response = rest.getForEntity(url + "/" + id, User.class);
        if (response.getStatusCode() == HttpStatus.OK) {
            User user = response.getBody();
            model.addAttribute("user", user);
            return "Auth/edit"; // Trả về view chỉnh sửa người dùng
        } else {
            redirectAttributes.addFlashAttribute("error", "User not found");
            return "redirect:/"; // Chuyển hướng về danh sách người dùng nếu không tìm thấy
        }
    }

    // Xử lý form chỉnh sửa người dùng
    @PostMapping("/edituser/{id}")
    public String editUser(Model model, @PathVariable int id, @ModelAttribute("user") User updatedUser, RedirectAttributes redirectAttributes) {
        try {
            // Gọi API để cập nhật thông tin người dùng
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<User> request = new HttpEntity<>(updatedUser, headers);
            updatedUser.setStatus("Activated");
            updatedUser.setRole("User");

            ResponseEntity<User> response = rest.exchange(
                    url + "/edituser",
                    HttpMethod.PUT,
                    request,
                    User.class);

            if (response.getStatusCode() == HttpStatus.CREATED) {
                redirectAttributes.addFlashAttribute("success", "User updated successfully");
                return "redirect:/userdetails/" + id; // Chuyển hướng về trang chi tiết người dùng sau khi cập nhật thành công
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to update user");
                return "redirect:/edituser/" + id; // Chuyển hướng về form chỉnh sửa nếu cập nhật thất bại
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error updating user: " + ex.getMessage());
            return "redirect:/edituser/" + id; // Chuyển hướng về form chỉnh sửa nếu có lỗi xảy ra
        }
    }

    @PostMapping("/updateUserStatus/{id}")
    public String updateOrderStatus(@PathVariable("id") int id,
            @RequestParam("status") String newStatus,
            RedirectAttributes redirectAttributes) {
        String updateUrl = url + "/updateStatus/{id}?status={status}";

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
                redirectAttributes.addFlashAttribute("Activated", true);
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to update status");
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error: " + ex.getMessage());
        }

        return "redirect:/listuser"; // Redirect to order details page
    }

    @GetMapping("/userdetailsadmin/{id}")
    public String UserDetails(Model model, @PathVariable int id, RedirectAttributes redirectAttributes, HttpSession session) {
        try {
            // Check if user is logged in
            String username = (String) session.getAttribute("username");
            model.addAttribute("username", username);
            if (username == null) {
                return "redirect:/login";
            }

            // Fetch user details
            ResponseEntity<User> response = rest.getForEntity(url + "/userdetails/" + id, User.class);
            if (response.getStatusCode() == HttpStatus.OK) {
                User user = response.getBody();
                model.addAttribute("user", user);

                // Fetch orders
                ResponseEntity<List<Orders>> ordersResponse = rest.exchange(
                        urlorders,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<List<Orders>>() {
                }
                );
                List<Orders> orders = ordersResponse.getBody();
                model.addAttribute("orders", orders);

                return "Auth/detailsadmin"; // Return the details view with user and orders
            } else {
                redirectAttributes.addFlashAttribute("error", "User details not found");
                return "redirect:/listuser"; // Redirect to user list if user not found
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error fetching user details: " + ex.getMessage());
            return "redirect:/listuser"; // Redirect to user list on error
        }
    }

}
