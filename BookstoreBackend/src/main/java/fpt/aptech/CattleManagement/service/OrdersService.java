/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;

import fpt.aptech.CattleManagement.entities.Orders;
import fpt.aptech.CattleManagement.repository.OrdersRepository;
import fpt.aptech.CattleManagement.repository.ProductRepository;
import fpt.aptech.CattleManagement.repository.ProductcartRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

/**
 *
 * @author admin
 */
@Service
public class OrdersService {

    @Autowired
    OrdersRepository ordersRepository;
    @Autowired
    ProductRepository productRepository;
    @Autowired
    ProductcartRepository productcartRepository;

    JavaMailSender javaMailSender;

    public OrdersService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public List<Orders> FindAll() {
        return ordersRepository.findAll();
    }

    public Page<Orders> getAll(int pageNo) {
        Pageable pageable = PageRequest.of(pageNo - 1, 5);
        return ordersRepository.findAllOrderByDescendingId(pageable);
    }

    public Orders findbyId(int id) {
        return ordersRepository.findById(id).get();
    }

    public Orders findById(int id) {
        Optional<Orders> optionalOrder = ordersRepository.findById(id);
        return optionalOrder.orElse(null);
    }

    public void save(Orders neworder) {
        ordersRepository.save(neworder);

    }

    public Orders updateorders(Orders uporders) {
        return ordersRepository.save(uporders);
    }

    public void deleteorders(int id) {
        Orders cart = ordersRepository.findById(id).get();
        ordersRepository.delete(cart);
    }
   

    public Orders updateOrderStatus(int id, String newStatus,boolean sendEmail) {
        Optional<Orders> optionalOrder = ordersRepository.findById(id);
        if (optionalOrder.isPresent()) {
            Orders order = optionalOrder.get();

            // Kiểm tra và chuyển đổi status
            if ("In progress".equals(order.getStatus())) {
                order.setStatus("Completed");
            } else if ("Completed".equals(order.getStatus())) {
                order.setStatus("In progress");
            } else {
                // Trường hợp khác nếu cần xử lý
                order.setStatus(newStatus);
            }

            Orders ordersend = ordersRepository.save(order);
            // Gửi email nếu được yêu cầu
            if (sendEmail) {
                sendemailstatus(ordersend);
            }
            return ordersend;
        }
        return null;
    }

    public void sendemailstatus(Orders order) {
    MimeMessage mailMessage = javaMailSender.createMimeMessage();
    MimeMessageHelper helper = new MimeMessageHelper(mailMessage, "utf-8");

    try {
        // Thiết lập người nhận email
        helper.setTo(order.getUserId().getEmail());

        // Thiết lập tiêu đề email
        helper.setSubject("Thông tin hóa đơn #" + order.getId());

        // Tạo nội dung email dạng HTML
        StringBuilder content = new StringBuilder();
        content.append("<html><body>");
        content.append("<div style='font-family: Arial, sans-serif; color: #333;'>");
        content.append("<div style='background-color: #99ff99; padding: 20px; text-align: center;'>");
        content.append("<h1 style='margin: 0;'>Thank you for your Order</h1>");
        content.append("</div>");
        content.append("<div style='padding: 20px;'>");
        content.append("<p><strong>Subject:</strong> ").append(order.getUserId().getUsername()).append("</p>");
        content.append("<p><strong>Thông tin hóa đơn #</strong>").append(order.getId()).append("</p>");
        content.append("<p>We’re happy to let you know that we’ve received your order.</p>");
        content.append("<p>Once your package ships, we will send you an email with a tracking number and link so you can see the movement of your package.</p>");
        content.append("<p>If you have any questions, contact us here or call us on <strong>[035 207 4902]</strong>!</p>");
        content.append("<p>We are here to help!</p>");
        content.append("<p><strong>Returns:</strong> If you would like to return your product(s), please see here <a href='[link]'>link</a> or contact us.</p>");
        content.append("</div>");
        content.append("<div style='background-color: #f8f9fa; padding: 10px; text-align: center;'>");
        content.append("<p style='margin: 0;'>Best regards,</p>");
        content.append("<p style='margin: 0;'>Team COFFEE PAO</p>");
        content.append("</div>");
        content.append("<div style='background-color: #f8f9fa; padding: 10px; text-align: center;'>");
        content.append("<p style='margin: 0;'>© 2024 Your Website Coffee Management System<a class='col_1' th:href='@{/}'>Coffee PAO</a></p>");
        content.append("</div>");
        content.append("</div>");
        content.append("</body></html>");

        helper.setText(content.toString(), true); // Đặt tham số true để cho phép HTML

        // Gửi email
        javaMailSender.send(mailMessage);
        System.out.println("Email sent successfully!");

    } catch (MessagingException | MailException e) {
        e.printStackTrace();
        throw new RuntimeException("Failed to send email");
    }
}



    // Thêm phương thức in hóa đơn
    public void printOrder(int id) {
        Optional<Orders> optionalOrder = ordersRepository.findById(id);
        if (optionalOrder.isPresent()) {
            Orders order = optionalOrder.get();

            // In hóa đơn (ví dụ: in ra console)
            System.out.println("Printing order:");

            System.out.println("User ID: " + order.getUserId().getEmail());
//            System.out.println("Update Date: " + order.getUpdatedate());
//            System.out.println("Payments: " + order.getPayments());
//            System.out.println("Items: " + order.getItems());
//            System.out.println("Status: " + order.getStatus());
//            System.out.println("SubTotal: " + order.getTotal());

            sendEmail(order);
        }
    }

  public void sendEmail(Orders order) {
    MimeMessage mailMessage = javaMailSender.createMimeMessage();
    MimeMessageHelper helper = new MimeMessageHelper(mailMessage, "utf-8");

    try {
        // Thiết lập người nhận email
        helper.setTo(order.getUserId().getEmail());

        // Thiết lập tiêu đề email
        helper.setSubject("Thông tin hóa đơn #" + order.getId());

        // Tạo nội dung email dạng HTML
        StringBuilder content = new StringBuilder();
        content.append("<html><body>");
        content.append("<div style='font-family: Arial, sans-serif; color: #333;'>");
        content.append("<div style='background-color: #99ff99; padding: 20px; text-align: center;'>");
        content.append("<span style='font-size: 24px; color: #333;'>Coffee</span>");
        content.append("<span style='font-size: 24px; color: #333;'>PAO</span>");
        content.append("</div>");

        // Bảng chi tiết đơn hàng
        content.append("<div style='padding: 20px;'>");
        content.append("<h2>Thông tin hóa đơn #" + order.getId() + "</h2>");
        content.append("<table style='width: 100%; border-collapse: collapse;'>");
        content.append("<tr style='background-color: #f8f9fa;'>");
        content.append("<th style='padding: 8px; text-align: left;'>Thông tin</th>");
        content.append("<th style='padding: 8px; text-align: left;'>Chi tiết</th>");
        content.append("</tr>");
        content.append("<tr>");
        content.append("<td style='padding: 8px;'><strong>Order ID:</strong></td>");
        content.append("<td style='padding: 8px;'>").append(order.getId()).append("</td>");
        content.append("</tr>");
        content.append("<tr>");
        content.append("<td style='padding: 8px;'><strong>Email:</strong></td>");
        content.append("<td style='padding: 8px;'>").append(order.getUserId().getEmail()).append("</td>");
        content.append("</tr>");
        content.append("<tr>");
        content.append("<td style='padding: 8px;'><strong>Update Date:</strong></td>");
        content.append("<td style='padding: 8px;'>").append(order.getUpdatedate()).append("</td>");
        content.append("</tr>");
        content.append("<tr>");
        content.append("<td style='padding: 8px;'><strong>Payments:</strong></td>");
        content.append("<td style='padding: 8px;'>").append(order.getPayments()).append("</td>");
        content.append("</tr>");
        content.append("<tr>");
        content.append("<td style='padding: 8px;'><strong>Items:</strong></td>");
        content.append("<td style='padding: 8px;'>").append(order.getItems()).append("</td>");
        content.append("</tr>");
        content.append("<tr>");
        content.append("<td style='padding: 8px;'><strong>Status:</strong></td>");
        content.append("<td style='padding: 8px;'>").append(order.getStatus()).append("</td>");
        
      
        
        content.append("</tr>");
        content.append("<tr>");
        content.append("<td style='padding: 8px;'><strong>SubTotal:</strong></td>");
        content.append("<td style='padding: 8px;'>").append(order.getTotal()).append("</td>");
        content.append("</tr>");
        content.append("</table>");
        content.append("</div>");

        content.append("<div style='background-color: #f8f9fa; padding: 10px; text-align: center;'>");
        content.append("<p style='margin: 0;'>Best regards,</p>");
        content.append("<p style='margin: 0;'>Team COFFEE PAO</p>");
        content.append("</div>");
        content.append("<div style='background-color: #f8f9fa; padding: 10px; text-align: center;'>");
        content.append("<p style='margin: 0;'>© 2024 Your Website Coffee Management System<a class='col_1' href='https://yourwebsite.com'>Coffee PAO</a></p>");
        content.append("</div>");
        content.append("</div>");
        content.append("</body></html>");

        helper.setText(content.toString(), true); // Đặt tham số true để cho phép HTML

        // Gửi email
        javaMailSender.send(mailMessage);
        System.out.println("Email sent successfully!");

    } catch (MessagingException | MailException e) {
        e.printStackTrace();
        throw new RuntimeException("Failed to send email");
    }
}
  

// 


    
    
    
    public List<Orders> findByUpdatedate(String fromDate, String toDate) {
        return ordersRepository.findByUpdatedate(fromDate, toDate);
    }

}
