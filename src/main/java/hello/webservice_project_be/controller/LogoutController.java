package hello.webservice_project_be.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/logout")
public class LogoutController {
    
    private static final String LOGIN_PAGE_URL = "http://walab.handong.edu:8080/W25_22400742_1/login.jsp";
    
    @GetMapping
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:" + LOGIN_PAGE_URL;
    }
    
    @PostMapping
    public String logoutPost(HttpSession session) {
        return logout(session);
    }
}

