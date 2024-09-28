/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;

import fpt.aptech.CattleManagement.entities.Orders;
import fpt.aptech.CattleManagement.entities.User;
import fpt.aptech.CattleManagement.repository.AuthRepository;
import fpt.aptech.CattleManagement.repository.OrdersRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

/**
 *
 * @author admin
 */
@Service
public class AuthService {

    @Autowired
    AuthRepository authRepository;
    @Autowired
    OrdersRepository ordersRepository;

    JavaMailSender javaMailSender;

    public AuthService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public User UserbyId(@PathVariable int id) {
        return authRepository.findById(id).get();
    }

    public List<Orders> FindAll() {
        return ordersRepository.findAll();
    }

    public void Useredit(User edituser) {
        authRepository.save(edituser);
    }

    public User createUser(User newUser) {
        // Kiểm tra xem email đã tồn tại chưa
        if (authRepository.existsByEmail(newUser.getEmail())) {
            return null;
        }

        // Lưu thông tin người dùng vào cơ sở dữ liệu và trả về người dùng đã được lưu
        return authRepository.save(newUser);
    }

    public void deleteUser(int id) {
        authRepository.deleteById(id);
    }

    public Page<User> getAll(int pageNo) {
        Pageable pageable = PageRequest.of(pageNo - 1, 5);
        return authRepository.findAllOrderByDescendingId(pageable);
    }

    // ham details
    public User getUserById(int id) {
        return authRepository.findById(id).orElse(null);
    }

    public User updateUserStatus(int id, String newStatus, boolean sendEmail) {
    Optional<User> optionalUser = authRepository.findById(id);
    if (optionalUser.isPresent()) {
        User user = optionalUser.get();

        // Kiểm tra và chuyển đổi status
        if ("Not Activated".equals(user.getStatus()) && "Activated".equals(newStatus)) {
            user.setStatus("Activated");
            if (sendEmail) {
                sendEmailUser(user);
            }
        } else if ("Activated".equals(user.getStatus()) && "Not Activated".equals(newStatus)) {
            user.setStatus("Not Activated");
            if (sendEmail) {
                sendEmailNot(user);
            }
        } else {
            // Trường hợp khác nếu cần xử lý
            user.setStatus(newStatus);
        }

        User updatedUser = authRepository.save(user);
        return updatedUser;
    }
    return null;
}

   public void sendEmailUser(User user) {
    MimeMessage mailMessage = javaMailSender.createMimeMessage();
    MimeMessageHelper helper = new MimeMessageHelper(mailMessage, "utf-8");

    try {
        // Thiết lập người nhận email
        helper.setTo(user.getEmail());

        // Thiết lập tiêu đề email
        helper.setSubject("Account Activation Notification");

        // Tạo nội dung email dạng HTML
        StringBuilder content = new StringBuilder();
        content.append("<html><body>");
        content.append("<div style='font-family: Arial, sans-serif; color: #333;'>");
        content.append("<div style='background-color: #99ff99; padding: 20px; text-align: center;'>");
        content.append("<h1 style='margin: 0;'>Account Activation Notification</h1>");
        content.append("</div>");
        content.append("<div style='padding: 20px;'>");
        content.append("<p>Hello ").append(user.getUsername()).append(",</p>");
        content.append("<p>Thank you for creating your account with us.</p>");
        content.append("<p>Your account has been activated!</p>");
        content.append("<p>Hope you enjoy our store's purchasing service in the near future.</p>");
        content.append("<p>Best regards,<br>Team COFFEE PAO</p>");
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


    public void sendEmailNot(User user) {
    MimeMessage mailMessage = javaMailSender.createMimeMessage();
    MimeMessageHelper helper = new MimeMessageHelper(mailMessage, "utf-8");

    try {
        // Thiết lập người nhận email
        helper.setTo(user.getEmail());

        // Thiết lập tiêu đề email
        helper.setSubject("Notice of Account Lockout");

        // Tạo nội dung email dạng HTML
        StringBuilder content = new StringBuilder();
        content.append("<html><body>");
        content.append("<div style='font-family: Arial, sans-serif; color: #333;'>");
        content.append("<div style='background-color: #99ff99; padding: 20px; text-align: center;'>");
        content.append("<h1 style='margin: 0;'>Notice of Account Lockout</h1>");
        content.append("</div>");
        content.append("<div style='padding: 20px;'>");
        content.append("<p>Hello ").append(user.getUsername()).append(",</p>");
        content.append("<p>Thank you for creating your account with us.</p>");
        content.append("<p>Your account has been locked.</p>");
        content.append("<p>If you have any complaints about your account, please see <a href='[link]'>here</a> or contact us.</p>");
        content.append("<p>Best regards,<br>Team COFFEE PAO</p>");
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

     public void sendEmailRegister(User user) {
    
    String subject = "Thank you for your feedback";
    String content = "Subject:"+ user.getUsername()+ "\n\n"  +
                 "We sincerely thank you for the feedback you have provided to us.\n\n" +
                 "Feedback details:\n" +
                 
                 "We will carefully review and process your feedback. If you have any further questions, please feel free to contact us.\n\n" +
                 "Best regards,\n" +
                 "Team COFFEE PAO";


    SimpleMailMessage mailMessage = new SimpleMailMessage();
    mailMessage.setTo("quicao902@gmail.com");
    mailMessage.setSubject(subject);
    mailMessage.setText(content);
    mailMessage.setSentDate(new Date());

    javaMailSender.send(mailMessage);
}
   
}
