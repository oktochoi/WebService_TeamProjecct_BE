package hello.webservice_project_be.controller;

import hello.webservice_project_be.model.User;
import hello.webservice_project_be.dao.UserDAO;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.UUID;

@Controller
@RequestMapping("/github-auth")
public class GitHubAuthController {
    
    private final UserDAO userDAO = new UserDAO();
    
    // Controller 초기화 확인
    public GitHubAuthController() {
        System.out.println("========================================");
        System.out.println("[GitHubAuthController] Controller 인스턴스 생성됨");
        System.out.println("========================================");
    }
    
    // GitHub OAuth 설정
    // ⚠️ 중요: GitHub에서 OAuth App을 생성하고 아래 값들을 설정해야 합니다!
    // 설정 방법: GITHUB_OAUTH_QUICK_SETUP.md 파일 참고
    // https://github.com/settings/developers 에서 OAuth App 생성
    private static final String GITHUB_CLIENT_ID = "Ov23lieOAWQRxryvvmaG"; // GitHub OAuth App Client ID
    private static final String GITHUB_CLIENT_SECRET = "e26f9d26385d2c46bc5ccb45fbb5de5cf4a8d599"; // ⚠️ Client Secret도 생성해서 입력하세요!
    private static final String GITHUB_REDIRECT_URI =
            "http://localhost:8080/WebService_Project_BE_war_exploded/github-auth/callback";
    private static final String GITHUB_API_URL = "https://api.github.com/user";
    
    /**
     * GitHub OAuth 인증 시작
     */
    @GetMapping(value = "/oauth")
    public void startOAuth(HttpSession session, 
                          javax.servlet.http.HttpServletRequest request,
                          javax.servlet.http.HttpServletResponse response) throws java.io.IOException {
        System.out.println("========================================");
        System.out.println("[GitHubAuthController] OAuth 시작");
        System.out.println("[GitHubAuthController] 요청 URI: " + request.getRequestURI());
        System.out.println("[GitHubAuthController] Context Path: " + request.getContextPath());
        
        // State 생성 (CSRF 방지)
        String state = java.util.UUID.randomUUID().toString();
        session.setAttribute("oauth_state", state);
        System.out.println("[GitHubAuthController] OAuth State 생성: " + state);
        
        // GitHub OAuth 인증 URL 생성
        String encodedRedirectUri;
        try {
            encodedRedirectUri = java.net.URLEncoder.encode(GITHUB_REDIRECT_URI, "UTF-8");
        } catch (java.io.UnsupportedEncodingException e) {
            encodedRedirectUri = GITHUB_REDIRECT_URI; // 폴백
        }
        
        String oauthUrl = "https://github.com/login/oauth/authorize" +
            "?client_id=" + GITHUB_CLIENT_ID +
            "&redirect_uri=" + encodedRedirectUri +
            "&scope=user:email" +
            "&state=" + state;
        
        System.out.println("[GitHubAuthController] OAuth URL: " + oauthUrl);
        System.out.println("[GitHubAuthController] GitHub로 리다이렉트");
        response.sendRedirect(oauthUrl);
    }
    
    /**
     * GitHub OAuth 콜백 처리
     */
    @GetMapping(value = "/callback")
    public String handleCallback(@RequestParam(required = false) String code,
                                 @RequestParam(required = false) String state,
                                 @RequestParam(required = false) String error,
                                 HttpSession session,
                                 javax.servlet.http.HttpServletRequest request) {
        System.out.println("========================================");
        System.out.println("[GitHubAuthController] OAuth 콜백 처리 시작");
        System.out.println("[GitHubAuthController] 요청 URI: " + request.getRequestURI());
        System.out.println("[GitHubAuthController] Context Path: " + request.getContextPath());
        System.out.println("[GitHubAuthController] Query String: " + request.getQueryString());
        System.out.println("[GitHubAuthController] code: " + (code != null ? "있음" : "없음"));
        System.out.println("[GitHubAuthController] state: " + state);
        System.out.println("[GitHubAuthController] error: " + error);
        
        try {
            // 에러 처리
            if (error != null) {
                System.err.println("[GitHubAuthController] GitHub OAuth 에러: " + error);
                return "redirect:/login.jsp?error=" + error;
            }
            
            // State 검증
            String savedState = (String) session.getAttribute("oauth_state");
            if (savedState == null || !savedState.equals(state)) {
                System.err.println("[GitHubAuthController] State 불일치 - saved: " + savedState + ", received: " + state);
                return "redirect:/login.jsp?error=invalid_state";
            }
            
            if (code == null) {
                System.err.println("[GitHubAuthController] Authorization code 없음");
                return "redirect:/login.jsp?error=no_code";
            }
            
            System.out.println("[GitHubAuthController] Access Token 요청 시작");
            // Access Token 요청
            String accessToken = getAccessToken(code);
            if (accessToken == null) {
                System.err.println("[GitHubAuthController] Access Token 획득 실패");
                return "redirect:/login.jsp?error=token_failed";
            }
            
            System.out.println("[GitHubAuthController] 사용자 정보 요청 시작");
            // 사용자 정보 가져오기
            JSONObject userInfo = getUserInfoFromGitHub(accessToken);
            if (userInfo != null) {
                System.out.println("[GitHubAuthController] 사용자 정보 획득 성공: " + userInfo.optString("login"));
                saveUserSession(session, userInfo, accessToken);
                System.out.println("[GitHubAuthController] 대시보드로 리다이렉트");
                return "redirect:/dashboard.jsp";
            } else {
                System.err.println("[GitHubAuthController] 사용자 정보 획득 실패");
                return "redirect:/login.jsp?error=auth_failed";
            }
        } catch (Exception e) {
            System.err.println("[GitHubAuthController] 콜백 처리 오류: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/login.jsp?error=server_error";
        }
    }
    
    
    /**
     * 세션에 사용자 정보 저장
     */
    private void saveUserSession(HttpSession session, JSONObject userInfo, String token) {
        System.out.println("[GitHubAuthController] 세션 저장 시작");
        String username = userInfo.optString("login", "");
        String email = userInfo.optString("email", "");
        
        session.setAttribute("username", username);
        session.setAttribute("name", userInfo.optString("name", ""));
        session.setAttribute("email", email);
        session.setAttribute("avatar", userInfo.optString("avatar_url", ""));
        session.setAttribute("githubToken", token);
        session.setAttribute("authenticated", true);
        
        // 세션 유효성 확보
        session.setMaxInactiveInterval(30 * 60); // 30분
        
        System.out.println("[GitHubAuthController] 세션 저장 완료 - username: " + session.getAttribute("username"));
        
        // DB에 사용자 없으면 생성
        persistUserIfAbsent(username, email);
    }
    
    /**
     * GitHub OAuth Access Token 획득
     */
    private String getAccessToken(String code) throws Exception {
        System.out.println("[GitHubAuthController] Access Token 요청 시작 - code: " + code.substring(0, Math.min(10, code.length())) + "...");
        
        String tokenUrl = "https://github.com/login/oauth/access_token";
        URL url = new URL(tokenUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Accept", "application/json");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);
            
            String params = "client_id=" + GITHUB_CLIENT_ID +
                          "&client_secret=" + GITHUB_CLIENT_SECRET +
                          "&code=" + code +
                          "&redirect_uri=" + java.net.URLEncoder.encode(GITHUB_REDIRECT_URI, "UTF-8");
            
            System.out.println("[GitHubAuthController] Access Token 요청 파라미터 전송");
            try (java.io.OutputStream os = conn.getOutputStream()) {
                byte[] input = params.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            
            int responseCode = conn.getResponseCode();
            System.out.println("[GitHubAuthController] Access Token API 응답 코드: " + responseCode);
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String inputLine;
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                JSONObject jsonResponse = new JSONObject(response.toString());
                String accessToken = jsonResponse.optString("access_token", null);
                
                if (accessToken != null) {
                    System.out.println("[GitHubAuthController] Access Token 획득 성공");
                } else {
                    System.err.println("[GitHubAuthController] Access Token 응답: " + response.toString());
                }
                
                return accessToken;
            } else {
                // 에러 응답 읽기
                BufferedReader errorReader = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                StringBuilder errorResponse = new StringBuilder();
                String errorLine;
                
                while ((errorLine = errorReader.readLine()) != null) {
                    errorResponse.append(errorLine);
                }
                errorReader.close();
                
                System.err.println("[GitHubAuthController] Access Token API 오류 응답: " + errorResponse.toString());
                return null;
            }
        } finally {
            conn.disconnect();
        }
    }

    /**
     * DB에 사용자 레코드가 없으면 생성
     */
    private void persistUserIfAbsent(String username, String email) {
        if (username == null || username.isEmpty()) {
            System.err.println("[GitHubAuthController] persistUserIfAbsent - username 비어 있음, 저장 건너뜀");
            return;
        }
        try {
            User existing = userDAO.findByUsername(username);
            if (existing == null) {
                User user = new User();
                user.setUsername(username);
                user.setUserPassword(UUID.randomUUID().toString()); // placeholder
                user.setEmail(email);
                user.setUserRole("USER");
                userDAO.create(user);
                System.out.println("[GitHubAuthController] 새 사용자 생성: " + username);
            } else {
                System.out.println("[GitHubAuthController] 기존 사용자 존재: " + username);
            }
        } catch (SQLException e) {
            System.err.println("[GitHubAuthController] 사용자 저장 실패: " + e.getMessage());
        }
    }
    
    /**
     * GitHub API에서 사용자 정보 가져오기
     */
    private JSONObject getUserInfoFromGitHub(String token) throws Exception {
        System.out.println("[GitHubAuthController] GitHub API 호출 시작");
        URL url = new URL(GITHUB_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "token " + token);
            conn.setRequestProperty("Accept", "application/vnd.github.v3+json");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);
            
            int responseCode = conn.getResponseCode();
            System.out.println("[GitHubAuthController] GitHub API 응답 코드: " + responseCode);
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String inputLine;
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                JSONObject userInfo = new JSONObject(response.toString());
                System.out.println("[GitHubAuthController] 사용자 정보 획득: " + userInfo.optString("login"));
                return userInfo;
            } else {
                System.err.println("[GitHubAuthController] GitHub API 오류 응답 코드: " + responseCode);
                return null;
            }
        } finally {
            conn.disconnect();
        }
    }
}

