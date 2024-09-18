/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagementClient.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.List;

import lombok.Getter;

import lombok.Setter;

/**
 *
 * @author admin
 */
@Entity
@Table(name = "Product")
@Getter
@Setter

public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Column(name = "productname")
    private String productname;
    @Column(name = "sale")
    private Double sale;
    @Column(name = "image")
    private String image;
    @Column(name = "date")
    private String date;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "price")
    private double price;
    @Column(name = "quantity")
    private Integer quantity;
    @Column(name = " units")
    private String units;
    private String active;
    @Lob
    @Column(name = "description")
    private String description;
    @Column(name = "status")
    private String status;
    @JoinColumn(name = "categoryid", referencedColumnName = "id")
    @ManyToOne
    private Category categoryid;
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @ManyToOne
    private User userId;
    @OneToMany(mappedBy = "productid")
    @JsonIgnore
    private List<Productcart> productcarts;

    public Product() {
    }

    public Product(Integer id, String productname, Double sale, String image, String date, double price, Integer quantity, String units, String description, String status, Category categoryid, User userId, List<Productcart> productcarts) {
        this.id = id;
        this.productname = productname;
        this.sale = sale;
        this.image = image;
        this.date = date;
        this.price = price;
        this.quantity = quantity;
        this.units = units;
        this.description = description;
        this.status = status;
        this.categoryid = categoryid;
        this.userId = userId;
        this.productcarts = productcarts;
    }

    

}
