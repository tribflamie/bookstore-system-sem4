/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;

import fpt.aptech.CattleManagement.dto.PageDto;
import fpt.aptech.CattleManagement.dto.SignUpDto;
import fpt.aptech.CattleManagement.entities.Orders;
import fpt.aptech.CattleManagement.entities.User;
import fpt.aptech.CattleManagement.repository.AuthRepository;
import fpt.aptech.CattleManagement.service.AuthService;
import fpt.aptech.CattleManagement.service.OrdersService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
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
@RequestMapping("/api/auth")

public class AuthController {

    @Autowired
    AuthService authService;
    @Autowired
    OrdersService ordersService;
     

    private final AuthRepository authRepository;
    JavaMailSender javaMailSender;

    

    public AuthController(AuthRepository authRepository) {
        this.authRepository = authRepository;
    }
    @GetMapping("/alluser")
    public PageDto<User> getAllFeedback(
            @RequestParam(defaultValue = "1") int pageNo
            ) {
        Page<User> feedbackPage = authService.getAll(pageNo);

        PageDto<User> pageDto = new PageDto<>();
        pageDto.setContent(feedbackPage.getContent());
        pageDto.setTotalPages(feedbackPage.getTotalPages());

        return pageDto;
    }

    @GetMapping()
    @ResponseStatus(HttpStatus.OK)
    public List<User> findallcategory() {
        return authRepository.findAll();
    }
    @GetMapping("/orderhistory")
    @ResponseStatus(HttpStatus.OK)
    public List<Orders> findalloders() {
        return ordersService.FindAll();
    }

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public User UserbyId(@PathVariable int id) {
        return authService.UserbyId(id);
    }
    //@PostMapping("/create")
    //public void createUser(@RequestBody User newUser) {
     //   authService.createUser(newUser);
    //}
    @PostMapping("/create")
    public ResponseEntity<User> createUser(@RequestBody User newUser) {
                  
            // Lưu thông tin người dùng vào cơ sở dữ liệu
            User createdUser = authService.createUser(newUser);
            if(createdUser !=null){
                 return ResponseEntity.ok(createdUser);//luu thành công
            }else{
                 return ResponseEntity.status(HttpStatus.CONFLICT).build(); //ngược lại email có rồi trả về CONFLICT
            }           
    }



    @DeleteMapping("/delete/{id}")
    public void deleteUser(@PathVariable int id) {
        authService.deleteUser(id);
    }

    @PutMapping("/edituser")
    @ResponseStatus(HttpStatus.CREATED)
    public void editcategory(@RequestBody User updateuser) {
        authService.Useredit(updateuser);
    }

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@RequestBody SignUpDto newUser) {
        // Kiểm tra xem username đã tồn tại chưa
        if (authRepository.findByEmail(newUser.getEmail()) != null) {
            return ResponseEntity.status(HttpStatus.FOUND).body("Email already exists");
        }
        // Lưu thông tin người dùng vào cơ sở dữ liệu
        User user = new User();
        user.setUsername(newUser.getUsername());
        user.setEmail(newUser.getEmail());
        user.setPassword(newUser.getPassword());
        user.setPhone(newUser.getPhone());
        user.setCountry(newUser.getCountry());
        user.setStatus("Activated");
        user.setRole("User");
        authRepository.save(user);
         
        return ResponseEntity.status(HttpStatus.OK).body("User registered successfully");
    }
    
    


   @PostMapping("/login")
public ResponseEntity<User> loginUser(@RequestBody User user) {
    User existingUser = authRepository.findByEmail(user.getEmail());
    
    if (existingUser != null && existingUser.getPassword().equals(user.getPassword())) {
        // Kiểm tra trạng thái của người dùng
        if (!"Activated".equals(existingUser.getStatus())) {
            // Trả về lỗi nếu người dùng không được kích hoạt
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        switch (existingUser.getRole()) {
            case "Admin":
            case "Employee":
            case "User":
                // Trường hợp đăng nhập thành công, trả về thông tin người dùng và mã trạng thái ACCEPTED (200)
                return ResponseEntity.ok(existingUser);
            default:
                // Trường hợp vai trò không hợp lệ, trả về mã trạng thái FORBIDDEN (403)
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    } else {
        // Trường hợp đăng nhập không thành công, trả về mã trạng thái UNAUTHORIZED (401)
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}


@GetMapping("/userdetails/{id}")
public ResponseEntity<User> getUserDetails(@PathVariable int id) {
    User user = authService.getUserById(id);
    if (user != null) {
        return ResponseEntity.ok(user); // Trả về thông tin người dùng nếu tìm thấy
    } else {
        return ResponseEntity.notFound().build(); // Trả về mã HTTP 404 Not Found nếu không tìm thấy người dùng
    }
}

 @PostMapping("/updateStatus/{id}")
    public ResponseEntity<String> updateOrderStatus(@PathVariable("id") int id, @RequestParam("status") String newStatus) {
        User updatedOrder = authService.updateUserStatus(id, newStatus, true);

        if (updatedOrder != null) {
            return ResponseEntity.ok("Status updated successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }



 



}
