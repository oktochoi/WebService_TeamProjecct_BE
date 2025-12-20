package hello.webservice_project_be.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/logout")
public class LogoutController {

    private static final Logger logger = LoggerFactory.getLogger(LogoutController.class);

    @GetMapping
    public void logout(HttpServletRequest request, HttpServletResponse response) {
        try {
            logger.info("[LogoutController] logout invoked. requestURI={}", request.getRequestURI());
            HttpSession session = request.getSession(false);
            logger.debug("[LogoutController] session exists={}", (session != null));
            if (session != null) {
                session.invalidate();
                logger.info("[LogoutController] session invalidated");
            }
            // Use sendRedirect with context path to avoid view resolver issues
            String target = request.getContextPath() + "/login.jsp";
            logger.info("[LogoutController] redirecting to {}", target);
            response.sendRedirect(target);
        } catch (Exception e) {
            logger.error("[LogoutController] error during logout: {}", e.getMessage(), e);
            try {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } catch (Exception io) {
                // best effort
                logger.warn("[LogoutController] best effort redirect failed", io);
            }
        }
    }

    @PostMapping
    public void logoutPost(HttpServletRequest request, HttpServletResponse response) {
        logout(request, response);
    }
}
