/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagementClient.dto;

import fpt.aptech.CattleManagementClient.entities.User;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * @author AnhLinh
 */
public class BlogDto {
    private Integer id;
    
    private String name;
   
    private String date;
    
    private String description;
    
    private String content;
    
    private MultipartFile image;
     
    private String status;
    private String active;
    
    private User userId;

    public BlogDto() {
    }

    public BlogDto(Integer id, String name, String date, String description, String content, MultipartFile image, String status, String active, User userId) {
        this.id = id;
        this.name = name;
        this.date = date;
        this.description = description;
        this.content = content;
        this.image = image;
        this.status = status;
        this.active = active;
        this.userId = userId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public MultipartFile getImage() {
        return image;
    }

    public void setImage(MultipartFile image) {
        this.image = image;
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

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }
    
}
