/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagementClient.dto;

import fpt.aptech.CattleManagementClient.entities.Category;
import io.micrometer.common.lang.Nullable;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * @author admin
 */
public class ProductDto {

    private Integer id;
    @NotNull(message = "Productname is required")
    @Size(min = 1, message = "Productname cannot be empty")
    private String productname;
    @NotNull(message = "Sale is required")
    @Size(min = 1, message = "Sale cannot be empty")
    @Positive(message = "Sale must be greater than 0")
    private Double sale;

    private MultipartFile image;
    @NotNull(message = "Date is required")
    @Size(min = 1, message = "Date cannot be empty")
    private String date;
    @NotNull(message = "Price is required")
    @Size(min = 1, message = "Price cannot be empty")
    @Positive(message = "Price must be greater than 0")
    private double price;
    @NotNull(message = "Quantity is required")
    @Size(min = 1, message = "Quantity cannot be empty")
    private Integer quantity;
    @Nullable
    @Size(min = 1, message = "Units cannot be empty")
    private String units;
    @NotNull(message = "Description is required")
    @Size(min = 1, message = "Description cannot be empty")
    private String description;
    
    private String status;
    private String active;

    private Category categoryid;

    public ProductDto() {
    }

    public ProductDto(Integer id, String productname, Double sale, MultipartFile image, String date, double price, Integer quantity, String units, String description, String status, String active, Category categoryid) {
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
        this.active = active;
        this.categoryid = categoryid;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getProductname() {
        return productname;
    }

    public void setProductname(String productname) {
        this.productname = productname;
    }

    public Double getSale() {
        return sale;
    }

    public void setSale(Double sale) {
        this.sale = sale;
    }

    public MultipartFile getImage() {
        return image;
    }

    public void setImage(MultipartFile image) {
        this.image = image;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getUnits() {
        return units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public Category getCategoryid() {
        return categoryid;
    }

    public void setCategoryid(Category categoryid) {
        this.categoryid = categoryid;
    }

    
}
