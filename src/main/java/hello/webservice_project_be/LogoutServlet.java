package hello.webservice_project_be;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "logoutServlet", value = "/legacy-logout")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate();
        }
        // use context path to redirect properly
        String target = request.getContextPath() + "/login.jsp";
        // Try to set Location header and send status first
        response.setStatus(HttpServletResponse.SC_FOUND); // 302
        response.setHeader("Location", target);
        response.setContentType("text/html;charset=UTF-8");
        // Provide small HTML fallback in case redirects are blocked
        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html>");
            out.println("<html><head><meta charset=\"utf-8\">\n<meta http-equiv=\"refresh\" content=\"0;url=" + target + "\">\n<title>로그아웃</title></head>");
            out.println("<body style=\"background:#fff;color:#111;font-family:Arial,Helvetica,sans-serif;\">\n<p>로그아웃 중입니다. 자동으로 이동하지 않으면 <a href=\"" + target + "\">여기를 클릭</a>하세요.</p>");
            out.println("</body></html>");
            out.flush();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        doGet(request, response);
    }
}
