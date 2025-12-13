package hello.webservice_project_be.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class JSPController {
    
    @GetMapping("/login.jsp")
    public ModelAndView login() {
        return new ModelAndView("/login.jsp");
    }
    
    @GetMapping("/index.jsp")
    public ModelAndView index() {
        return new ModelAndView("/index.jsp");
    }
    
    @GetMapping("/dashboard.jsp")
    public ModelAndView dashboard() {
        return new ModelAndView("/dashboard.jsp");
    }
    
    @GetMapping("/project-detail.jsp")
    public ModelAndView projectDetail() {
        return new ModelAndView("/project-detail.jsp");
    }
    
    @GetMapping("/settings.jsp")
    public ModelAndView settings() {
        return new ModelAndView("/settings.jsp");
    }
    
    @GetMapping("/profile.jsp")
    public ModelAndView profile() {
        return new ModelAndView("/profile.jsp");
    }
}
