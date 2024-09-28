/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagement.entities;


import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;
import lombok.*;


/**
 *
 * @author admin
 */
@Entity
@Table(name = "Category")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @NotNull(message = "Categoryname is required")
    @Size(min = 1, message = "Categoryname cannot be empty")
    @Column(name = "categoryname")
    private String categoryname;
    @Column(name = "status")
    private String status;
    @OneToMany(mappedBy = "categoryid")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private List<Product> productList;
}
