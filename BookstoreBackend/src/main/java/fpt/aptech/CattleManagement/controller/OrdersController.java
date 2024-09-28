/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/RestController.java to edit this template
 */
package fpt.aptech.CattleManagement.controller;


import fpt.aptech.CattleManagement.dto.PageDto;
import fpt.aptech.CattleManagement.entities.Orders;
import fpt.aptech.CattleManagement.service.OrdersService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 *
 * @author admin
 */
@RestController
@RequestMapping("/api/orders")
public class OrdersController {

    @Autowired
    OrdersService ordersService;

    @GetMapping()
    @ResponseStatus(HttpStatus.OK)
    public List<Orders> findalloders() {
        return ordersService.FindAll();
    }

    @GetMapping("/allorder")
    public PageDto<Orders> getAllFeedback(
            @RequestParam(defaultValue = "1") int pageNo
    ) {
        Page<Orders> feedbackPage = ordersService.getAll(pageNo);

        PageDto<Orders> pageDto = new PageDto<>();
        pageDto.setContent(feedbackPage.getContent());
        pageDto.setTotalPages(feedbackPage.getTotalPages());

        return pageDto;
    }

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Orders findbyidorder(@PathVariable int id) {
        return ordersService.findbyId(id);
    }

    @PostMapping("/createoders")
    @ResponseStatus(HttpStatus.CREATED)
    public void saveprodutcart(@RequestBody Orders neworders) {
        ordersService.save(neworders);
    }
     

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteorders(@PathVariable int id) {
        ordersService.deleteorders(id);
    }

    @PutMapping("/editorders")
    @ResponseStatus(HttpStatus.OK)
    public Orders editproductcart(@RequestBody Orders uporders) {
        return ordersService.updateorders(uporders);
    }

    @PostMapping("/updateStatus/{id}")
    public ResponseEntity<String> updateOrderStatus(@PathVariable("id") int id, @RequestParam("status") String newStatus) {
        Orders updatedOrder = ordersService.updateOrderStatus(id, newStatus, true);

        if (updatedOrder != null) {
            return ResponseEntity.ok("Status updated successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    

    @GetMapping("/print/{id}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<String> printOrder(@PathVariable int id) {
        try {
            ordersService.printOrder(id);
            return ResponseEntity.ok("Order printed successfully");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to print order");
        }
    }
     
    
    @GetMapping("/findByDateRange")
    public ResponseEntity<List<Orders>> findByDateRange(
            @RequestParam("fromDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) String fromDate,
            @RequestParam("toDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) String toDate
    ) {
        List<Orders> orders = ordersService.findByUpdatedate(fromDate, toDate);
        return ResponseEntity.ok(orders);
    }

    

}
