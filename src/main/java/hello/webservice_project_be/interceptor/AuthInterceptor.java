package hello.webservice_project_be.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        logger.debug("[AuthInterceptor] preHandle 시작 - URI: {}", request.getRequestURI());

        try {
            HttpSession session = request.getSession(false);
            logger.debug("[AuthInterceptor] 세션 존재: {}", (session != null));

            if (session != null) {
                Object authenticated = session.getAttribute("authenticated");
                logger.debug("[AuthInterceptor] authenticated 속성: {}", authenticated);
                logger.debug("[AuthInterceptor] username: {}", session.getAttribute("username"));
            }
            
            Object authAttr = (session != null) ? session.getAttribute("authenticated") : null;
            boolean isAuthenticated = false;
            if (authAttr instanceof Boolean) {
                isAuthenticated = (Boolean) authAttr;
            } else if (authAttr != null) {
                isAuthenticated = Boolean.parseBoolean(String.valueOf(authAttr));
            }

            logger.debug("[AuthInterceptor] 인증 상태: {}", isAuthenticated);

            if (!isAuthenticated) {
                logger.info("[AuthInterceptor] 인증 실패 - 리다이렉트");
                // AJAX 요청인 경우
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    logger.info("[AuthInterceptor] AJAX 요청 - 401 반환");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"error\":\"인증이 필요합니다.\"}");
                } else {
                    // 일반 요청인 경우
                    logger.info("[AuthInterceptor] 일반 요청 - 로그인 페이지로 리다이렉트");
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                }
                return false;
            }
            
            logger.debug("[AuthInterceptor] 인증 성공 - 요청 계속");
            return true;
        } catch (Exception e) {
            logger.error("[AuthInterceptor] 오류 발생: {}", e.getMessage(), e);
            throw e;
        }
    }
    
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        logger.debug("[AuthInterceptor] postHandle - URI: {}, Status: {}", request.getRequestURI(), response.getStatus());
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        if (ex != null) {
            logger.error("[AuthInterceptor] afterCompletion - 오류 발생: {}", ex.getMessage(), ex);
        } else {
            logger.debug("[AuthInterceptor] afterCompletion - 정상 완료");
        }
    }
}
