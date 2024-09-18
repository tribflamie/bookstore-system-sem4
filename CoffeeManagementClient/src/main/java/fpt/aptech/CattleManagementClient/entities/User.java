/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagementClient.entities;

/**
 *
 * @author admin
 */
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.List;
import lombok.Data;

@Data
@Entity
@Table(name = "users", uniqueConstraints = {
   
    @UniqueConstraint(columnNames = {"email"})
})
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @NotNull(message = "Username is required")
    @Size(min = 1, message = "Username cannot be empty")
    private String username;
    @NotNull(message = "Email number is required")
    @Size(min = 1, message = "Email cannot be empty")
    @Email(message = "Email should be valid")
    private String email;
    @NotNull(message = "Password number is required")
    @Size(min = 1, message = "password cannot be empty")
    private String password;
    @NotNull(message = "Address is required")
    @Size(min = 1, message = "Address cannot be empty")
    private String country;
    @NotNull(message = "Phone is required")
    @Pattern(regexp="\\d{10}", message="Phone number must be 10 digits")
    private String phone;
    private String status;
    private String role;

  
    @OneToMany(mappedBy = "userId")
    @JsonIgnore
    private List<Product> productList;
    
    @OneToMany(mappedBy = "userId")
    @JsonIgnore
    private List<Productcart> productcarts;
    @OneToMany(mappedBy = "userId")
    @JsonIgnore
    private List<Blog> blogs;
}
