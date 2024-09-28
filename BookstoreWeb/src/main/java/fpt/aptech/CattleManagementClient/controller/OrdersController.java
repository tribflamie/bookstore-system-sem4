/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.dto.PageDto;
import fpt.aptech.CattleManagementClient.entities.Orders;
import fpt.aptech.CattleManagementClient.entities.Productcart;
import fpt.aptech.CattleManagementClient.entities.User;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author admin
 */
@Controller
public class OrdersController {

    private String urlorders = "http://localhost:9999/api/orders";
    private String urlproductcart = "http://localhost:9999/api/productcart";
    private RestTemplate rest = new RestTemplate();

    @RequestMapping("/checkout")
    public String checkout(Model model, HttpSession session) {
        double totalAmount = 0.0;
        int totalIterations = 0;

        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        model.addAttribute("orders", new Orders());
        model.addAttribute("productcart", new Productcart());
//        Map<Integer, Integer> userIdCounts = new HashMap<>();
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
                    totalIterations++;
                }
            }
        }
        model.addAttribute("totalIterations", totalIterations);
        model.addAttribute("totlal", totalAmount);
        return "Home/order/checkout";
    }

    @SuppressWarnings("unused")
    @PostMapping("/checkout")
    public String page(Model model, HttpSession session, RedirectAttributes redirectAttributes,
            @ModelAttribute("orders") Orders orders, @ModelAttribute("productcart") Productcart productcart) {
        Integer userone = (Integer) session.getAttribute("user");
        User user = new User();
        user.setId(userone);
        orders.setUserId(user);
        orders.setProductcartid(productcart);
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // Định dạng ngày tháng năm
        orders.setUpdatedate(date.toString()); // Gán ngày tháng năm đã định dạng vào thuộc tính updatedate

        orders.setStatus("In progress");

        ResponseEntity<List<Productcart>> productcarts = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
        }
        );
        List<Productcart> p = productcarts.getBody();
        

        for (Productcart productcart1 : p) {
            if (productcart1.getStatus() == false) {
                productcart.setId(productcart1.getId());
                productcart.setQuantity(productcart1.getQuantity());
                productcart.setSellingprice(productcart1.getSellingprice());
                productcart.setSubtotal(productcart1.getSubtotal());
                productcart.setProductid(productcart1.getProductid());
                productcart.setUserId(productcart1.getUserId());
                productcart.setStatus(true);
                productcart.setOrderses(productcart1.getOrderses());
                
                productcart.setStartdate(date.toString());
                String createUrl = urlproductcart + "/createproductcart";
                rest.postForEntity(createUrl, productcart, Productcart.class);
            }
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Orders> request = new HttpEntity<>(orders, headers);

        try {
            ResponseEntity<String> response = rest.exchange(
                    urlorders + "/createoders",
                    HttpMethod.POST,
                    request,
                    String.class);
            if (response.getStatusCode() == HttpStatus.CREATED) {
                return "Home/order/ordersuccess";
            } else {
                return "Admin/shopingcart/mycart";
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error during create: " + ex.getMessage());
            return "redirect:/errorPage";
        }
    }

    @RequestMapping("/order")
    public String function_allFeedback(Model model, HttpSession session, @RequestParam(defaultValue = "1") Integer pageNo) {
        // Truy xuất tên người dùng từ phiên làm việc
        String username = (String) session.getAttribute("username");
        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            case "Employee":
                // Gọi API để lấy danh sách người dùng
                ResponseEntity<PageDto<Orders>> response = rest.exchange(
                        urlorders + "/allorder?pageNo=" + pageNo,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<PageDto<Orders>>() {
                });

                if (response.getStatusCode() == HttpStatus.OK) {
                    PageDto<Orders> pageDto = response.getBody();

                    // Thêm thông tin vào model
                    model.addAttribute("username", username);
                    model.addAttribute("list", pageDto.getContent());
                    model.addAttribute("totalPages", pageDto.getTotalPages());
                    model.addAttribute("totalElements", pageDto.getTotalElements());
                    model.addAttribute("currentPage", pageNo);

                    // Calculate page numbers
                    List<Integer> pageNumbers = IntStream.rangeClosed(1, pageDto.getTotalPages()).boxed().collect(Collectors.toList());
                    model.addAttribute("pageNumbers", pageNumbers);

                    return "Home/order/order";
                } else {
                    // Handle error here
                    return "error";
                }
            default:
                return "redirect:/";
        }
    }

    @GetMapping("/detailsorder/{id}")
    public String detailsorder(@PathVariable int id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            case "Employee":
                model.addAttribute("username", username);
                String orderUrl = urlorders + "/" + id;
                Orders order = rest.getForObject(orderUrl, Orders.class);
                model.addAttribute("order", order);

                ResponseEntity<List<Productcart>> response = rest.exchange(
                        urlproductcart,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<List<Productcart>>() {
                });
                List<Productcart> productCarts = response.getBody();
                model.addAttribute("pcart", productCarts);

                return "Home/order/detailsorder";
            default:
                return "redirect:/";
        }
    }

    @GetMapping("/oroderedit/{id}")
    public String editorder(@PathVariable int id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            case "Employee":
                model.addAttribute("username", username);
                String orderUrl = urlorders + "/" + id;
                Orders order = rest.getForObject(orderUrl, Orders.class);
                model.addAttribute("order", order);

                ResponseEntity<List<Productcart>> response = rest.exchange(
                        urlproductcart,
                        HttpMethod.GET,
                        null,
                        new ParameterizedTypeReference<List<Productcart>>() {
                });
                List<Productcart> productCarts = response.getBody();
                model.addAttribute("pcart", productCarts);

                return "Home/order/oroderedit";
            default:
                return "redirect:/";
        }
    }

    @PostMapping("/oroderedit")
    public String updateorder(@ModelAttribute Orders updateOrders) {
        String orderurl = urlorders + "/editorders";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Orders> requestEntity = new HttpEntity<>(updateOrders, headers);
        ResponseEntity<String> response = rest.exchange(
                orderurl,
                HttpMethod.PUT,
                requestEntity,
                String.class
        );

        if (response.getStatusCode() == HttpStatus.OK) {
            return "redirect:/order";
        } else {
            return "Error/errorPage"; // Xử lý lỗi nếu cần
        }
    }

    @SuppressWarnings("unused")
    @GetMapping("/purchasehistory")
    public String purchasehistory(Model model, HttpSession session) {
        double totalAmount = 0.0;
        int totalIterations = 0;

        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        if (username == null) {
            return "redirect:/login";
        }

        ResponseEntity<List<Orders>> response = rest.exchange(
                urlorders,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Orders>>() {
        }
        );
        List<Orders> o = response.getBody();

        model.addAttribute("oders", o);

        return "Home/order/purchasehistory";
    }

    @GetMapping("/detailpurchasehistory/{id}")
    public String detailhistory(@PathVariable int id, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        model.addAttribute("username", username);
        if (username == null) {
            return "redirect:/login";
        }

        String orderone = urlorders + "/" + id;
        Orders orders = rest.getForObject(orderone, Orders.class);
        model.addAttribute("order", orders);

        ResponseEntity<List<Productcart>> response = rest.exchange(
                urlproductcart,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Productcart>>() {
        }
        );
        List<Productcart> p = response.getBody();

        model.addAttribute("pcart", p);

        return "Home/order/detailpurchasehistory";
    }

    @GetMapping("/ordersuccess")
    public String ordersuccess(Model model, HttpSession session) {
        return "Admin/shopingcart/mycart";
    }

    @PostMapping("/updateOrderStatus/{id}")
    public String updateOrderStatus(@PathVariable("id") int id,
            @RequestParam("status") String newStatus,
            RedirectAttributes redirectAttributes) {
        String updateUrl = urlorders + "/updateStatus/{id}?status={status}";

        // Prepare HTTP headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Create HTTP entity with updated status
        HttpEntity<String> requestEntity = new HttpEntity<>(headers);

        try {
            // Send POST request to update status
            ResponseEntity<String> response = rest.exchange(
                    updateUrl,
                    HttpMethod.POST,
                    requestEntity,
                    String.class,
                    id,
                    newStatus
            );

            // Check response status
            if (response.getStatusCode() == HttpStatus.OK) {
                redirectAttributes.addFlashAttribute("Activated", "Status updated successfully");
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to update status");
            }
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error: " + ex.getMessage());
        }

        return "redirect:/order" ; // Redirect to order details page
    }

    @GetMapping("/printOrder/{id}")
    public String printOrder(@PathVariable int id, Model model, RedirectAttributes redirectAttributes) {
        String endpointUrl = urlorders + "/print/" + id;

        try {
            ResponseEntity<String> response = rest.getForEntity(endpointUrl, String.class);
            if (response.getStatusCode().is2xxSuccessful()) {
                redirectAttributes.addFlashAttribute("printsuccess", "Order printed successfully");
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to print order");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error: " + e.getMessage());
        }

        return "redirect:/detailsorder/" + id; // Redirect to order details page after printing
    }

}
