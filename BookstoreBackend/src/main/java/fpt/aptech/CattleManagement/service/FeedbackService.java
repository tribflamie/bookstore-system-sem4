/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/springframework/Service.java to edit this template
 */
package fpt.aptech.CattleManagement.service;

import fpt.aptech.CattleManagement.entities.Feedback;
import fpt.aptech.CattleManagement.repository.FeedbackRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.data.domain.Pageable;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

/**
 *
 * @author ASUS
 */
@Service
public class FeedbackService {
     @Autowired
    FeedbackRepository feedbackRepository;
    JavaMailSender javaMailSender;

    /**
     * Constructor của FeedbackService.
     * @param javaMailSender Đối tượng JavaMailSender để gửi email.
     */
    public FeedbackService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    /**
     * Phương thức này gửi email phản hồi cho người dùng.
     * @param feedback Đối tượng Feedback chứa thông tin phản hồi.
     */
    public void sendFeedback(Feedback feedback) {
        String str = "XYZ COP";
        SimpleMailMessage mailMessage = new SimpleMailMessage();
        mailMessage.setTo(feedback.getSender(), feedback.getSender());
        mailMessage.setSubject(feedback.getSubject());
        mailMessage.setText(str + "\n" + feedback.getContent());

        mailMessage.setSentDate(new Date());
       

        javaMailSender.send(mailMessage);
    }

    /**
     * Phương thức này lưu trữ phản hồi vào cơ sở dữ liệu.
     * @param newFeedback Đối tượng Feedback mới cần được lưu trữ.
     */
    public void saveFeedback(Feedback newFeedback) {
        Date date = new Date();
        newFeedback.setDated(date.toString());
        newFeedback.markAsPending();
        newFeedback.markAsUnresolved();
        feedbackRepository.save(newFeedback);
    }

    /**
     * Phương thức này trả về danh sách tất cả các phản hồi trong cơ sở dữ liệu.
     * @return Danh sách Feedback.
     */
    public List<Feedback> findAllFeedback() {
        return feedbackRepository.findAll();
    }
    // Sửa lại phương thức getAll để trả về một trang danh mục
    public Page<Feedback> getAll(int pageNo) {
        Pageable pageable = PageRequest.of(pageNo - 1, 5);
        return feedbackRepository.findAllOrderByDescendingId(pageable);
    }

    /**
     * Phương thức này xóa một phản hồi từ cơ sở dữ liệu.
     * @param feedbackId ID của phản hồi cần xóa.
     */
   
    public void deletefeedback(int id){
      Feedback feedback = feedbackRepository.findById(id).get();
      feedbackRepository.delete(feedback);
    }
    
    // Tìm kiếm dịch vụ theo từ khóa
    public List<Feedback> searchServices(String sender) {
        return feedbackRepository.searchByNameIgnoreCaseContaining(sender);
    }
     public Feedback findbyId(int id) {
        return feedbackRepository.findById(id).get();
    }
    
//    public Feedback updateFeedbackStatus(int id, String newStatus) {
//        Optional<Feedback> optionalOrder = feedbackRepository.findById(id);
//        if (optionalOrder.isPresent()) {
//            Feedback order = optionalOrder.get();
//
//            // Kiểm tra và chuyển đổi status
//            if ("Unresolved".equals(order.getStatus())) {
//                order.setStatus("Solved");
//            } else if ("Solved".equals(order.getStatus())) {
//                order.setStatus("Unresolved");
//            } else {
//                // Trường hợp khác nếu cần xử lý
//                order.setStatus(newStatus);
//            }
//
//            return feedbackRepository.save(order);
//        }
//        return null;
//    }
     public Feedback updateFeedbackStatus(int id, String newStatus, boolean sendEmail) {
    Optional<Feedback> optionalFeedback = feedbackRepository.findById(id);
    if (optionalFeedback.isPresent()) {
        Feedback feedback = optionalFeedback.get();

        // Kiểm tra và chuyển đổi status
        if ("Unresolved".equals(feedback.getStatus())) {
            feedback.setStatus("Solved");
        } else if ("Solved".equals(feedback.getStatus())) {
            feedback.setStatus("Unresolved");
        } else {
            // Trường hợp khác nếu cần xử lý
            feedback.setStatus(newStatus);
        }

        // Lưu feedback sau khi cập nhật status
        Feedback updatedFeedback = feedbackRepository.save(feedback);

        // Gửi email nếu được yêu cầu
        if (sendEmail) {
            sendFeedbackUser(updatedFeedback);
        }

        return updatedFeedback;
    }
    return null;
}

    public void sendFeedbackUser(Feedback feedback) {
    MimeMessage mailMessage = javaMailSender.createMimeMessage();
    MimeMessageHelper helper = new MimeMessageHelper(mailMessage, "utf-8");

    try {
        // Thiết lập người nhận email
        helper.setTo(feedback.getSender());

        // Thiết lập tiêu đề email
        helper.setSubject("Thank you for your feedback");

        // Tạo nội dung email dạng HTML
        StringBuilder content = new StringBuilder();
        content.append("<html><body>");
        content.append("<div style='font-family: Arial, sans-serif; color: #333;'>");
        content.append("<div style='background-color: #99ff99; padding: 20px; text-align: center;'>");
        content.append("<h1 style='margin: 0;'>Thank you for your Feedback</h1>");
        content.append("</div>");
        content.append("<div style='padding: 20px;'>");
        content.append("<p><strong>Subject:</strong> ").append(feedback.getSubject()).append("</p>");
        content.append("<p>We sincerely thank you for the feedback you have provided to us.</p>");
        content.append("<p><strong>Feedback details:</strong><br>").append(feedback.getContent()).append("</p>");
        content.append("<p>We will carefully review and process your feedback. If you have any further questions, please feel free to contact us.</p>");
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


}
