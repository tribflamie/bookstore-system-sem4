/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagement.entities;

/**
 *
 * @author admin
 */
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "users", uniqueConstraints = {
   
    @UniqueConstraint(columnNames = {"email"})
})
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @NotNull(message = "Username is required")
    private String username;
    @NotNull(message = "Email number is required")
    @Email(message = "Email should be valid")
    private String email;
    @NotNull(message = "Password number is required")
    private String password;
    @NotNull(message = "Address is required")
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
    @OneToMany(mappedBy = "userId")
    @JsonIgnore
    private List<Orders> orderses;
}
