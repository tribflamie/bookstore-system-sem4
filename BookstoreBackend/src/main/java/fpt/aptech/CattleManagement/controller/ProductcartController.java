/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;

import fpt.aptech.CattleManagement.entities.Productcart;
import fpt.aptech.CattleManagement.service.ProductcartService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;


/**
 *
 * @author admin
 */
@RestController
@RequestMapping("/api/productcart")
public class ProductcartController {

    @Autowired
    ProductcartService productcartService;

    @GetMapping()
    @ResponseStatus(HttpStatus.OK)
    public List<Productcart> findallproductcart() {
        return productcartService.FindAll();
    }

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Productcart findbyidproductcart(@PathVariable int id) {
        return productcartService.findbyId(id);
    }

    @PostMapping("/createproductcart")
    @ResponseStatus(HttpStatus.CREATED)
    public void saveprodutcart(@RequestBody Productcart newproductcart) {
        productcartService.save(newproductcart);
    }
    

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteproductcart(@PathVariable int id) {
        productcartService.deletecart(id);
    }

    @PutMapping("/editproductcart")
    @ResponseStatus(HttpStatus.OK)
    public Productcart editproductcart(@RequestBody Productcart upproductcart) {
        return productcartService.updatecart(upproductcart);
    }
     

}
