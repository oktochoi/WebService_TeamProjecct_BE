package hello.webservice_project_be.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import hello.webservice_project_be.dao.UserDAO;
import hello.webservice_project_be.model.User;
import hello.webservice_project_be.service.ProjectService;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin1234";
    
    private final UserDAO userDAO = new UserDAO();
    
    @Autowired
    private ProjectService projectService;
    
    /**
     * 관리자 로그인 페이지
     */
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        // 이미 관리자로 로그인한 경우 회원 관리 페이지로 리다이렉트
        if (session != null && session.getAttribute("adminAuthenticated") != null && 
            (Boolean) session.getAttribute("adminAuthenticated")) {
            return "redirect:/admin/users";
        }
        return "admin-login";
    }
    
    /**
     * 관리자 로그인 처리
     */
    @PostMapping("/login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {
        
        // 관리자 인증
        if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
            session.setAttribute("adminAuthenticated", true);
            session.setAttribute("adminUsername", username);
            System.out.println("[AdminController] 관리자 로그인 성공: " + username);
            return "redirect:/admin/users";
        } else {
            System.out.println("[AdminController] 관리자 로그인 실패: " + username);
            try {
                return "redirect:/admin/login?error=" + URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다.", "UTF-8");
            } catch (UnsupportedEncodingException e) {
                return "redirect:/admin/login?error=로그인 실패";
            }
        }
    }
    
    /**
     * 회원 관리 페이지
     */
    @GetMapping("/users")
    public String usersPage(HttpSession session, Model model) {
        // 관리자 인증 확인
        if (session == null || session.getAttribute("adminAuthenticated") == null || 
            !(Boolean) session.getAttribute("adminAuthenticated")) {
            try {
                return "redirect:/admin/login?error=" + URLEncoder.encode("관리자 권한이 필요합니다.", "UTF-8");
            } catch (UnsupportedEncodingException e) {
                return "redirect:/admin/login?error=인증 필요";
            }
        }
        
        try {
            List<User> users = userDAO.getAllUsers();
            model.addAttribute("users", users);
            System.out.println("[AdminController] 회원 목록 조회: " + users.size() + "명");
        } catch (SQLException e) {
            System.err.println("[AdminController] 회원 목록 조회 오류: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "회원 목록을 불러오는 중 오류가 발생했습니다.");
        }
        
        return "admin-users";
    }
    
    /**
     * 회원 삭제
     */
    @PostMapping("/users/delete")
    public String deleteUser(
            @RequestParam("userId") int userId,
            HttpSession session) {
        
        // 관리자 인증 확인
        if (session == null || session.getAttribute("adminAuthenticated") == null || 
            !(Boolean) session.getAttribute("adminAuthenticated")) {
            try {
                return "redirect:/admin/login?error=" + URLEncoder.encode("관리자 권한이 필요합니다.", "UTF-8");
            } catch (UnsupportedEncodingException e) {
                return "redirect:/admin/login?error=인증 필요";
            }
        }
        
        try {
            // 현재 로그인한 관리자 자신은 삭제할 수 없도록 체크
            User user = userDAO.getUserById(userId);
            
            if (user != null && ADMIN_USERNAME.equals(user.getUsername())) {
                System.out.println("[AdminController] 관리자 계정은 삭제할 수 없습니다.");
                try {
                    return "redirect:/admin/users?error=" + URLEncoder.encode("관리자 계정은 삭제할 수 없습니다.", "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    return "redirect:/admin/users?error=삭제 불가";
                }
            }
            
            // 유저 삭제 전에 해당 유저의 모든 프로젝트 삭제
            if (user != null && user.getUsername() != null) {
                try {
                    projectService.deleteAllProjectsByUserId(user.getUsername());
                    System.out.println("[AdminController] 사용자의 모든 프로젝트 삭제 완료: userId=" + userId);
                } catch (Exception e) {
                    System.err.println("[AdminController] 프로젝트 삭제 중 오류 발생: " + e.getMessage());
                    // 프로젝트 삭제 실패해도 유저 삭제는 계속 진행
                }
            }
            
            boolean deleted = userDAO.deleteUser(userId);
            if (deleted) {
                System.out.println("[AdminController] 회원 삭제 성공: userId=" + userId);
                return "redirect:/admin/users?success=true";
            } else {
                System.out.println("[AdminController] 회원 삭제 실패: userId=" + userId);
                try {
                    return "redirect:/admin/users?error=" + URLEncoder.encode("회원 삭제에 실패했습니다.", "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    return "redirect:/admin/users?error=삭제 실패";
                }
            }
        } catch (SQLException e) {
            System.err.println("[AdminController] 회원 삭제 오류: " + e.getMessage());
            try {
                return "redirect:/admin/users?error=" + URLEncoder.encode("회원 삭제 중 오류가 발생했습니다.", "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                return "redirect:/admin/users?error=오류 발생";
            }
        }
    }
    
    /**
     * 관리자 로그아웃
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute("adminAuthenticated");
            session.removeAttribute("adminUsername");
        }
        return "redirect:/admin/login";
    }
}

