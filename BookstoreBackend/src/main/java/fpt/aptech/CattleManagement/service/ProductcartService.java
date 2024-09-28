/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;


import fpt.aptech.CattleManagement.entities.Productcart;
import fpt.aptech.CattleManagement.repository.ProductcartRepository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author admin
 */
@Service
public class ProductcartService {
    
    
    @Autowired
    ProductcartRepository productcartRepository;
    
    public List<Productcart> FindAll() {
        return productcartRepository.findAll();
    }
    
    public Productcart findbyId(int id) {
        return productcartRepository.findById(id).get();
    }
    
    public void save(Productcart newproductcart) {
        productcartRepository.save(newproductcart);
    }
    
    public Productcart updatecart(Productcart upproductcart) {
        return productcartRepository.save(upproductcart);
    }
    
    public void deletecart(int id) {
        Productcart cart = productcartRepository.findById(id).get();
        productcartRepository.delete(cart);
    }
   
    
}
