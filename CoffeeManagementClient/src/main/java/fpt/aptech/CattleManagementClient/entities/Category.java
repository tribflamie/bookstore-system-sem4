/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagementClient.entities;


import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

/**
 *
 * @author admin
 */
@Entity
@Table(name = "Category")
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

    public Category() {
    }

    public Category(Integer id, String categoryname, String status, List<Product> productList) {
        this.id = id;
        this.categoryname = categoryname;
        this.status = status;
        this.productList = productList;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCategoryname() {
        return categoryname;
    }

    public void setCategoryname(String categoryname) {
        this.categoryname = categoryname;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Product> getProductList() {
        return productList;
    }

    public void setProductList(List<Product> productList) {
        this.productList = productList;
    }
    
    
}
