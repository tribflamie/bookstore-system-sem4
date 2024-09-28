/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Controller.java to edit this template
 */
package fpt.aptech.CattleManagementClient.controller;

import fpt.aptech.CattleManagementClient.entities.Orders;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

/**
 *
 * @author admin
 */
@Controller
public class AdminController {

    private String urlorders = "http://localhost:9999/api/orders";
    private String urlproduct = "http://localhost:9999/api/product";

    private RestTemplate rest = new RestTemplate();

    @GetMapping("/admin")
    public String page(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return "redirect:/login";
        }

        // Kiểm tra vai trò của người dùng
        switch (username) {
            case "Admin":
            case "Employee":
                model.addAttribute("username", username);
                break;
            default:
                return "redirect:/";
        }

        double totalamount = 0.0;

        ResponseEntity<String> productcount = rest.getForEntity(urlproduct + "/countproduct", String.class);
        model.addAttribute("productcount", productcount.getBody());

        ResponseEntity<List<Orders>> totalmount = rest.exchange(
                urlorders,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Orders>>() {
        }
        );
        List<Orders> ordersList = totalmount.getBody();

        model.addAttribute("orders", ordersList);

        int countCash = 0;
        double totalCash = 0;
        int countPaypal = 0;
        double totalPaypal = 0;
        int countVnpay = 0;
        double totalVnpay = 0;

        for (Orders orders : ordersList) {
            totalamount += orders.getTotal();

            if ("Completed".equals(orders.getStatus())) {
                if ("Cash On Delivery".equals(orders.getPayments())) {
                    totalCash += orders.getTotal();
                    countCash++;
                } else if ("paypal".equals(orders.getPayments())) {
                    totalPaypal += orders.getTotal();
                    countPaypal++;
                } else if ("VNPAY".equals(orders.getPayments())) {
                    totalVnpay += orders.getTotal();
                    countVnpay++;
                }
            }
        }

        model.addAttribute("totalamount", totalamount);
        model.addAttribute("cash", countCash);
        model.addAttribute("totalcash", totalCash);
        model.addAttribute("paypal", countPaypal);
        model.addAttribute("totalpaypal", totalPaypal);
        model.addAttribute("vnpay", countVnpay);
        model.addAttribute("totalvnpay", totalVnpay);

        double totalAmountCattle = 0.0;
        for (Orders order : ordersList) {
            if ("Completed".equals(order.getStatus())) { // Thêm điều kiện chỉ tính những đơn hàng ở trạng thái Completed

                totalAmountCattle += order.getTotal();
            }
        }

        model.addAttribute("totalamountcattle", totalAmountCattle);
        // Tính tổng số đơn hàng
        int totalOrders = ordersList.size();
        model.addAttribute("totalOrders", totalOrders);
        // Tính tổng số sản phẩm từ các đơn hàng
        int totalProductCount = 0;
        for (Orders order : ordersList) {
            totalProductCount += order.getItems(); // Lấy số lượng sản phẩm từ trường items của mỗi đơn hàng
        }
        model.addAttribute("totalProductCount", totalProductCount);
        return "/Admin/admin";
    }

//    @GetMapping("/count")
//    public String admin(Model model) {
//       
//        return "Admin/admin";
//    }
}
