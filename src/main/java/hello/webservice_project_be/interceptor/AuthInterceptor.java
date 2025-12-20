package hello.webservice_project_be.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthInterceptor implements HandlerInterceptor {
    
    private static final String LOGIN_PAGE_URL = "http://walab.handong.edu:8080/W25_22400742_1/login.jsp";
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("[AuthInterceptor] preHandle 시작 - URI: " + request.getRequestURI());
        
        try {
            HttpSession session = request.getSession(false);
            System.out.println("[AuthInterceptor] 세션 존재: " + (session != null));
            
            if (session != null) {
                Object authenticated = session.getAttribute("authenticated");
                System.out.println("[AuthInterceptor] authenticated 속성: " + authenticated);
                System.out.println("[AuthInterceptor] username: " + session.getAttribute("username"));
            }
            
            boolean isAuthenticated = (session != null && 
                session.getAttribute("authenticated") != null && 
                (Boolean) session.getAttribute("authenticated"));
            
            System.out.println("[AuthInterceptor] 인증 상태: " + isAuthenticated);
            
            if (!isAuthenticated) {
                System.out.println("[AuthInterceptor] 인증 실패 - 리다이렉트");
                // AJAX 요청인 경우
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    System.out.println("[AuthInterceptor] AJAX 요청 - 401 반환");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"error\":\"인증이 필요합니다.\"}");
                } else {
                    // 일반 요청인 경우
                    System.out.println("[AuthInterceptor] 일반 요청 - 로그인 페이지로 리다이렉트");
                    response.sendRedirect(LOGIN_PAGE_URL);
                }
                return false;
            }
            
            System.out.println("[AuthInterceptor] 인증 성공 - 요청 계속");
            return true;
        } catch (Exception e) {
            System.err.println("[AuthInterceptor] 오류 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("[AuthInterceptor] postHandle - URI: " + request.getRequestURI() + ", Status: " + response.getStatus());
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        if (ex != null) {
            System.err.println("[AuthInterceptor] afterCompletion - 오류 발생: " + ex.getMessage());
            ex.printStackTrace();
        } else {
            System.out.println("[AuthInterceptor] afterCompletion - 정상 완료");
        }
    }
}

