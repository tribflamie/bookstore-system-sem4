/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.entities.Productcart;
import fpt.aptech.CattleManagementClient.entities.User;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author admin
 */
@Controller
public class ProductcartController {

    private String urlproductcart = "http://localhost:9999/api/productcart";
    private RestTemplate rest = new RestTemplate();

    @GetMapping("/mycart")
    public String page(Model model, HttpSession session) {

        double totalAmount = 0.0;

        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("productcart", new Productcart());
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
        }
        );
        List<Productcart> p = response.getBody();

        model.addAttribute("pcart", p);

        for (Productcart productcart : p) {
            if (username == null) {
                return "Admin/shopingcart/mycart";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                      totalAmount += productcart.getSubtotal();
                }   
            }
        }
        model.addAttribute("totlal", totalAmount);

        return "Admin/shopingcart/mycart";
    }

    @PostMapping("/mycart")
    public String page(Model model, HttpSession session, RedirectAttributes redirectAttributes,
            @ModelAttribute("productcart") Productcart productcart) {
        double Subtotal;
        

        Integer userone = (Integer) session.getAttribute("user");
        User user = new User();
        user.setId(userone);
        productcart.setUserId(user);
        
        
        if (productcart.getQuantity() != null) {
            Subtotal = productcart.getQuantity() * productcart.getSellingprice();
            productcart.setSubtotal(Subtotal);
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Productcart> request = new HttpEntity<>(productcart, headers);

        try {
            ResponseEntity<String> response = rest.exchange(
                    urlproductcart + "/createproductcart",
                    HttpMethod.POST,
                    request,
                    String.class);
            if (response.getStatusCode() == HttpStatus.CREATED) {
                return "redirect:/mycart";
            } else {
                return "Admin/shopingcart/mycart";
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error during create: " + ex.getMessage());
            return "redirect:/errorPage";
        }
    }

    @GetMapping("/deleteproductcart/{id}")
    public String Deleteproductcart(@PathVariable int id, Model model) {
        String carturl = urlproductcart + "/" + id;
        try {
            rest.exchange(carturl, HttpMethod.DELETE, null, String.class);
            return "redirect:/mycart";
        } catch (Exception e) {
            return "Error/errorPage";
        }
    }
     

}
