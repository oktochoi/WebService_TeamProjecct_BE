package hello.webservice_project_be.controller.admin;

import hello.webservice_project_be.model.User;
import hello.webservice_project_be.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import hello.webservice_project_be.service.admin.AdminService;

@Controller
@RequestMapping("/admin")
public class AdminUserController {

    private static final Logger logger = LoggerFactory.getLogger(AdminUserController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private AdminService adminService;

    @GetMapping("/users")
    public String listUsers(Model model) {
        logger.info("[AdminUserController] /admin/users 호출");
        List<User> users = userService.listUsers();
        logger.info("[AdminUserController] 조회된 사용자 수: {}", users == null ? 0 : users.size());
        model.addAttribute("users", users);
        return "forward:/admin/user-list.jsp";
    }

    @PostMapping("/users/delete")
    public void deleteUser(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                logger.warn("[AdminUserController] 삭제 시도 - 세션 없음");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=not_authenticated");
                return;
            }

            Object loginUserObj = session.getAttribute("loginUser");
            if (!(loginUserObj instanceof User)) {
                logger.warn("[AdminUserController] 삭제 시도 - loginUser 속성 없음 또는 잘못된 타입");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=not_authorized");
                return;
            }

            User adminUser = (User) loginUserObj;

            String userIdParam = request.getParameter("userId");
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                logger.warn("[AdminUserController] 삭제 시도 - userId 파라미터 없음");
                response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
                return;
            }

            int userId;
            try {
                userId = Integer.parseInt(userIdParam.trim());
            } catch (NumberFormatException nfe) {
                logger.warn("[AdminUserController] 삭제 시도 - userId 파싱 실패: {}", userIdParam);
                response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id_format");
                return;
            }

            // 자기 자신 삭제 방지 (추가 방어)
            try {
                if (adminUser.getId() == userId) {
                    logger.warn("[AdminUserController] 관리자 본인 삭제 시도 차단 - id={}", userId);
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=cannot_delete_self");
                    return;
                }
            } catch (Exception ignore) {
                // adminUser.getId()가 -1 등일 수 있으므로 안전히 무시
            }

            boolean ok = adminService.deleteUserById(userId, adminUser);
            if (ok) {
                logger.info("[AdminUserController] 사용자 삭제 성공 - id={}", userId);
                response.sendRedirect(request.getContextPath() + "/admin/users?success=1");
            } else {
                logger.warn("[AdminUserController] 사용자 삭제 실패 - id={}", userId);
                response.sendRedirect(request.getContextPath() + "/admin/users?error=delete_failed");
            }
        } catch (Exception e) {
            logger.error("[AdminUserController] 사용자 삭제 중 예외: {}", e.getMessage(), e);
            try {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=server_error");
            } catch (java.io.IOException io) {
                logger.error("[AdminUserController] redirect 실패: {}", io.getMessage(), io);
            }
        }
    }
}
