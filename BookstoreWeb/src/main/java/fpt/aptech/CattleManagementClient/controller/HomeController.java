/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.entities.Comment;
import fpt.aptech.CattleManagementClient.entities.Feedback;
import fpt.aptech.CattleManagementClient.entities.Product;
import fpt.aptech.CattleManagementClient.entities.Productcart;
import fpt.aptech.CattleManagementClient.entities.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URI;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

/**
 *
 * @author admin
 */
@Controller
public class HomeController {

    private String urlproduct = "http://localhost:9999/api/product";
    private String urlCattle = "http://localhost:9999/api/cattle";
    private String urlca = "http://localhost:9999/api/category";
    private String urlcacttle = "http://localhost:9999/api/cattlecategory";
    private String urlcattlesold = "http://localhost:9999/api/cattlesale";
    private String urlproductcart = "http://localhost:9999/api/productcart";
    private String urlcomment = "http://localhost:9999/api/comment";
    private String urlblog = "http://localhost:9999/api/blog";
    @SuppressWarnings("unused")
    private final String apiUrl = "http://localhost:9999/api/feedbackcontroller";
    private RestTemplate rest = new RestTemplate();

    @GetMapping("/")
    public String page(Model model, HttpSession session, HttpServletRequest request) {
        double totalAmount = 0.0;

        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
        model.addAttribute("lblog", rest.getForObject(urlblog, List.class));
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username == null) {
                return "Home/home";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                    totalAmount += productcart.getSubtotal();
                }
            }
        }
        model.addAttribute("totlal", totalAmount);

        return "Home/home";
    }

    @GetMapping("/homedetails/{id}")
    public String detailsproduct(@PathVariable int id, Model model, HttpSession session) {
        String productone = urlproduct + "/" + id;
        Product product = rest.getForObject(productone, Product.class);
        // Gọi API để lấy averageRating của sản phẩm
        ResponseEntity<Double> response = rest.getForEntity(urlcomment + "/" + id, Double.class);
        double averageRating = response.getBody();

        model.addAttribute("product", product);
        model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
        model.addAttribute("pcart", rest.getForObject(urlproductcart, List.class));
        model.addAttribute("comment", rest.getForObject(urlcomment, List.class));
        model.addAttribute("averageRating", averageRating);

        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("productcart", new Productcart());
        model.addAttribute("comments", new Comment());

        return "Home/homedetails"; // Trả về tên của template HTML (editUser.html)
    }

    @PostMapping("/homedetails/{id}")
    public ResponseEntity<String> postDetailsProduct(@PathVariable int id, @ModelAttribute("comments") Comment comment,
            HttpSession session) {
        Integer userone = (Integer) session.getAttribute("user");
        User user = new User();
        user.setId(userone);
        comment.setUserId(user);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Comment> request = new HttpEntity<>(comment, headers);
        try {
            ResponseEntity<String> response = rest.exchange(
                    urlcomment + "/createcomment",
                    HttpMethod.POST,
                    request,
                    String.class);
            if (response.getStatusCode() == HttpStatus.CREATED) {
                // Trả về một redirect đến trang chi tiết sản phẩm
                return ResponseEntity.status(HttpStatus.FOUND)
                        .location(URI.create("/homedetails/" + id))
                        .build();
            } else {
                return new ResponseEntity<>("Failed to add comment", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception ex) {
            return new ResponseEntity<>("Error during create: " + ex.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/about")
    public String about(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username == null) {
                return "Home/about";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                    totalAmount += productcart.getSubtotal();
                }
            }
        }
        model.addAttribute("totlal", totalAmount);

        return "Home/about"; // Trả về tên của template HTML (editUser.html)
    }

    @GetMapping("/contactus")
    public String contactus(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
        model.addAttribute("feedback", new Feedback());
        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username == null) {
                return "Home/contactus";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                    totalAmount += productcart.getSubtotal();
                }
            }
        }
        model.addAttribute("totlal", totalAmount);
        return "Home/contactus"; // Trả về tên của template HTML (editUser.html)
    }

    // product
    @GetMapping("/products")
    public String products(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("cate", rest.getForObject(urlca, List.class));
        model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
        model.addAttribute("plist", rest.getForObject(urlproduct, List.class));
        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username == null) {
                return "Home/product/products";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                    totalAmount += productcart.getSubtotal();
                }
            }
        }
        model.addAttribute("totlal", totalAmount);

        model.addAttribute("productcart", new Productcart());
        return "Home/product/products"; // Trả về tên của template HTML (editUser.html)
    }

    @PostMapping("/products")
    public ResponseEntity<String> productcart(Model model, HttpSession session,
            @ModelAttribute("productcart") Productcart productcart) throws IOException {
        Integer userone = (Integer) session.getAttribute("user");

        User user = new User();
        user.setId(userone);
        productcart.setUserId(user);
        productcart.setQuantity(1);
        double subtotal = productcart.getQuantity() * productcart.getSellingprice();
        productcart.setSubtotal(subtotal);

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
                return ResponseEntity.status(HttpStatus.CREATED).header("Location", "/products").body("");
            } else {
                return new ResponseEntity<>("Failed to add product to cart", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception ex) {
            return new ResponseEntity<>("Error during create: " + ex.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/searchproduct")
    public String searchByName(Model model, HttpSession session, @RequestParam String productname) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("cate", rest.getForObject(urlca, List.class));
        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username != null) {
                if (username.equals(productcart.getUserId().getUsername())) {
                    if (productcart.getStatus() == false) {
                        totalAmount += productcart.getSubtotal();
                    }
                }
            }
        }
        model.addAttribute("totlal", totalAmount);
        model.addAttribute("username", username);

        if (productname == null) {
            model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
            model.addAttribute("plist", rest.getForObject(urlproduct, List.class));
            return "Home/product/products";
        } else {
            String productUrl = urlproduct + "/search?productname=" + productname;
            try {
                ResponseEntity<List<Product>> responseEntity = rest.exchange(
                        productUrl,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<List<Product>>() {
                        });

                List<Product> products = responseEntity.getBody();

                model.addAttribute("listp", products);
                model.addAttribute("plist", rest.getForObject(urlproduct, List.class));
            } catch (RestClientException e) {
                // Handle exceptions, log or return an error view
                return "error";
            }
            return "Home/product/products";
        }
    }

    @PostMapping("/filter")
    public String searchFilterPrice(Model model, @RequestParam(required = false) Double min,
            @RequestParam(required = false) Double max, HttpSession session) {

        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);

        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username != null) {
                if (username.equals(productcart.getUserId().getUsername())) {
                    if (productcart.getStatus() == false) {
                        totalAmount += productcart.getSubtotal();
                    }
                }
            }
        }
        model.addAttribute("totlal", totalAmount);

        model.addAttribute("cate", rest.getForObject(urlca, List.class));

        if (min == null && max == null) {
            model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
            model.addAttribute("plist", rest.getForObject(urlproduct, List.class));
            return "Home/product/products";
        } else {
            // Handle empty strings or non-numeric values if needed
            // For simplicity, assuming valid numeric values for min and max
            String productUrl = urlproduct + "/searchprice?min=" + min + "&max=" + max;
            try {
                ResponseEntity<List<Product>> responseEntity = rest.exchange(
                        productUrl,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<List<Product>>() {
                        });

                List<Product> products = responseEntity.getBody();

                model.addAttribute("listp", products);
                model.addAttribute("plist", rest.getForObject(urlproduct, List.class));
            } catch (RestClientException e) {
                // Handle exceptions, log or return an error view
                return "error";
            }

            // Redirect to "/product"
            return "Home/product/products";
        }
    }

    @PostMapping("/filtercategory")
    public String searchFiltercategory(Model model, @RequestParam("id") Integer categoryid, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("cate", rest.getForObject(urlca, List.class));
        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username != null) {
                if (username.equals(productcart.getUserId().getUsername())) {
                    if (productcart.getStatus() == false) {
                        totalAmount += productcart.getSubtotal();
                    }
                }
            }
        }
        model.addAttribute("totlal", totalAmount);
        model.addAttribute("username", username);
        if (categoryid == 0) {
            model.addAttribute("listp", rest.getForObject(urlproduct, List.class));
            model.addAttribute("plist", rest.getForObject(urlproduct, List.class));
            model.addAttribute("cate", rest.getForObject(urlca, List.class));
            return "Home/product/products";
        } else {
            String productUrl = urlproduct + "/bycategory?categoryid=" + categoryid;
            model.addAttribute("cate", rest.getForObject(urlca, List.class));
            try {
                ResponseEntity<List<Product>> responseEntity = rest.exchange(
                        productUrl,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<List<Product>>() {
                        });

                List<Product> products = responseEntity.getBody();

                model.addAttribute("listp", products);
                model.addAttribute("plist", rest.getForObject(urlproduct, List.class));
            } catch (RestClientException e) {
                // Handle exceptions, log or return an error view
                return "error";
            }
            return "Home/product/products";
        }
    }

    @GetMapping("/deletecart/{id}")
    public String Delete(@PathVariable int id, Model model) {
        String carturl = urlproductcart + "/" + id;
        try {
            rest.exchange(carturl, HttpMethod.DELETE, null, String.class);
            return "redirect:/products";
        } catch (Exception e) {
            return "Error/errorPage";
        }
    }

    // Cattle
    @GetMapping("/listcattle")
    public String cattle(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("clist", rest.getForObject(urlCattle, List.class));
        model.addAttribute("catecattle", rest.getForObject(urlcacttle, List.class));
        double totalAmount = 0.0;
        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
                });
        List<Productcart> p = response.getBody();
        model.addAttribute("pcart", p);
        for (Productcart productcart : p) {
            if (username == null) {
                return "Home/cattle/listcattle";
            }
            if (username.equals(productcart.getUserId().getUsername())) {
                if (productcart.getStatus() == false) {
                    totalAmount += productcart.getSubtotal();
                }
            }
        }
        model.addAttribute("totlal", totalAmount);

        return "Home/cattle/listcattle";
    }

    @RequestMapping("/cowbuyinghistory")
    public String Cowbuyinghistory(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        if (username == null) {
            return "redirect:/login";
        }
        model.addAttribute("list", rest.getForObject(urlcattlesold, List.class));
        return "Home/cattle/cowbuyinghistory";
    }
}
