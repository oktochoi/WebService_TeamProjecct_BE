package hello.webservice_project_be.controller.admin;

import hello.webservice_project_be.dao.UserDAO;
import hello.webservice_project_be.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@Controller
@RequestMapping("/admin")
public class AdminAuthController {

    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin1234";

    private final UserDAO userDAO = new UserDAO();

    @GetMapping("/login")
    public String showLoginPage() {
        // view resolver의 viewNames 설정 때문에 "admin/login"이 매칭되지 않아 뷰를 못찾는 문제 발생.
        // 명시적으로 JSP로 포워드하면 ViewResolver 필터링을 우회해 정확한 JSP를 렌더링합니다.
        return "forward:/admin/login.jsp";
    }

    @PostMapping("/login")
    public void login(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?admin_error=1");
            return;
        }

        if (!ADMIN_USERNAME.equals(username) || !ADMIN_PASSWORD.equals(password)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?admin_error=1");
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("authenticated", true);
        session.setAttribute("username", username);
        session.setAttribute("name", "관리자");
        session.setAttribute("email", "");

        // Try to load existing User from DB; if present, store it as loginUser. Otherwise create a minimal User object.
        try {
            User user = userDAO.findByUsername(username);
            if (user == null) {
                user = new User();
                user.setUsername(username);
                user.setUserRole("ADMIN");
                // id가 DB에 없으면 -1로 표기
                user.setId(-1);
            } else {
                // 보장: DB에 존재하면 role이 ADMIN인지 확인하고 강제로 ADMIN으로 설정하지 않음
                // 만약 DB의 role이 ADMIN이 아니라면 우선 강제로 ADMIN으로 간주하도록 세션에 설정
                if (user.getUserRole() == null || !user.getUserRole().equalsIgnoreCase("ADMIN")) {
                    user.setUserRole("ADMIN");
                }
            }
            session.setAttribute("loginUser", user);
        } catch (SQLException e) {
            // DB 접근 오류라 해도 세션에는 최소한의 관리자 정보를 넣어둠
            User user = new User();
            user.setUsername(username);
            user.setUserRole("ADMIN");
            user.setId(-1);
            session.setAttribute("loginUser", user);
        }

        // Redirect to controller that provides user list model
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
