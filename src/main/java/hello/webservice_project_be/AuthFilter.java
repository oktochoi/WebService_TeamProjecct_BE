package hello.webservice_project_be;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter(filterName = "authFilter", urlPatterns = {"/dashboard.jsp", "/project-detail.jsp", 
    "/settings.jsp", "/profile.jsp"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        boolean isAuthenticated = (session != null && 
            session.getAttribute("authenticated") != null && 
            (Boolean) session.getAttribute("authenticated"));
        
        if (!isAuthenticated) {
            httpResponse.sendRedirect("login.jsp");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    }
}

