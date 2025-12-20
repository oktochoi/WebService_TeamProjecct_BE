package hello.webservice_project_be.controller;

import hello.webservice_project_be.dao.UserDAO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/api/profile")
public class ProfileController {
    
    // 이미지 저장 디렉토리 (웹앱 루트의 uploads/profile 디렉토리)
    private static final String UPLOAD_DIR = "uploads/profile";
    
    private final UserDAO userDAO;
    
    @org.springframework.beans.factory.annotation.Autowired
    private ServletContext servletContext;
    
    public ProfileController() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * 프로필 이미지 업로드
     */
    @PostMapping("/upload-image")
    @ResponseBody
    public ResponseEntity<?> uploadImage(
            @RequestParam("image") MultipartFile file,
            HttpSession session) {
        
        try {
            // 세션 확인
            String username = (String) session.getAttribute("username");
            if (username == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "인증이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
            }
            
            // 파일 검증
            if (file.isEmpty()) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "파일이 비어있습니다.");
                return ResponseEntity.badRequest().body(error);
            }
            
            // 파일 크기 검증 (5MB)
            if (file.getSize() > 5 * 1024 * 1024) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "파일 크기는 5MB 이하여야 합니다.");
                return ResponseEntity.badRequest().body(error);
            }
            
            // 이미지 파일인지 확인
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "이미지 파일만 업로드할 수 있습니다.");
                return ResponseEntity.badRequest().body(error);
            }
            
            // 파일 확장자 추출
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            
            // 기존 파일 삭제 (같은 사용자의 이전 프로필 이미지) - 새 파일 저장 전에 삭제
            deleteOldProfileImage(username);
            
            // 고유한 파일명 생성 (username_timestamp_uuid.extension)
            String uniqueFilename = username + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + extension;
            
            // 웹앱 루트 기준으로 파일 저장 경로 설정
            String realPath = servletContext.getRealPath("/");
            if (realPath == null) {
                // 개발 환경에서는 프로젝트 루트 사용
                realPath = System.getProperty("user.dir");
            }
            Path uploadPath = Paths.get(realPath, UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
                System.out.println("[ProfileController] 업로드 디렉토리 생성: " + uploadPath.toAbsolutePath());
            }
            Path filePath = uploadPath.resolve(uniqueFilename);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            
            // 이미지 URL 생성 (상대 경로)
            String imageUrl = "/" + UPLOAD_DIR + "/" + uniqueFilename;
            
            // DB에 프로필 이미지 URL 저장
            try {
                userDAO.updateProfileImageUrl(username, imageUrl);
                System.out.println("[ProfileController] DB에 프로필 이미지 URL 저장 완료");
            } catch (SQLException e) {
                System.err.println("[ProfileController] DB 저장 오류: " + e.getMessage());
                // DB 저장 실패해도 파일은 업로드되었으므로 계속 진행
            }
            
            // 세션에도 이미지 URL 저장
            session.setAttribute("profileImageUrl", imageUrl);
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "true");
            response.put("imageUrl", imageUrl);
            response.put("message", "프로필 이미지가 업로드되었습니다.");
            
            System.out.println("[ProfileController] 프로필 이미지 업로드 성공: " + imageUrl);
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            System.err.println("[ProfileController] 이미지 업로드 IO 오류: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "파일 저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        } catch (Exception e) {
            System.err.println("[ProfileController] 이미지 업로드 오류: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            String errorMessage = e.getMessage();
            if (errorMessage == null || errorMessage.isEmpty()) {
                errorMessage = "알 수 없는 오류가 발생했습니다.";
            }
            // 파일 경로가 포함된 에러 메시지에서 경로 제거
            if (errorMessage.contains("uploads/")) {
                errorMessage = "파일 처리 중 오류가 발생했습니다.";
            }
            error.put("error", "이미지 업로드 중 오류가 발생했습니다: " + errorMessage);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    /**
     * 프로필 이미지 조회
     */
    @GetMapping("/image")
    @ResponseBody
    public ResponseEntity<?> getImage(HttpSession session) {
        try {
            String username = (String) session.getAttribute("username");
            if (username == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "인증이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
            }
            
            // DB에서 프로필 이미지 URL 조회
            String imageUrl = null;
            try {
                imageUrl = userDAO.getProfileImageUrl(username);
                if (imageUrl != null) {
                    // 세션에도 저장
                    session.setAttribute("profileImageUrl", imageUrl);
                }
            } catch (SQLException e) {
                System.err.println("[ProfileController] DB 조회 오류: " + e.getMessage());
                // DB 조회 실패 시 세션에서 확인
                imageUrl = (String) session.getAttribute("profileImageUrl");
            }
            
            Map<String, String> response = new HashMap<>();
            if (imageUrl != null) {
                // 파일이 실제로 존재하는지 확인
                String filename = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
                String realPath = servletContext.getRealPath("/");
                if (realPath == null) {
                    realPath = System.getProperty("user.dir");
                }
                Path filePath = Paths.get(realPath, UPLOAD_DIR, filename);
                if (Files.exists(filePath)) {
                    response.put("imageUrl", imageUrl);
                } else {
                    // 파일이 없으면 DB와 세션에서 제거
                    try {
                        userDAO.updateProfileImageUrl(username, null);
                    } catch (SQLException e) {
                        System.err.println("[ProfileController] DB 업데이트 오류: " + e.getMessage());
                    }
                    session.removeAttribute("profileImageUrl");
                }
            }
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("[ProfileController] 이미지 조회 오류: " + e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", "이미지 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    /**
     * 프로필 이미지 제거
     */
    @PostMapping("/remove-image")
    @ResponseBody
    public ResponseEntity<?> removeImage(HttpSession session) {
        try {
            String username = (String) session.getAttribute("username");
            if (username == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "인증이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
            }
            
            // 기존 파일 삭제
            deleteOldProfileImage(username);
            
            // DB에서 프로필 이미지 URL 제거
            try {
                userDAO.updateProfileImageUrl(username, null);
                System.out.println("[ProfileController] DB에서 프로필 이미지 URL 제거 완료");
            } catch (SQLException e) {
                System.err.println("[ProfileController] DB 업데이트 오류: " + e.getMessage());
            }
            
            // 세션에서 이미지 URL 제거
            session.removeAttribute("profileImageUrl");
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "true");
            response.put("message", "프로필 이미지가 제거되었습니다.");
            
            System.out.println("[ProfileController] 프로필 이미지 제거 성공");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("[ProfileController] 이미지 제거 오류: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "이미지 제거 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    /**
     * 프로필 정보 저장 (이름, 이메일)
     */
    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<?> saveProfile(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            HttpSession session) {
        
        try {
            String username = (String) session.getAttribute("username");
            if (username == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "인증이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
            }
            
            // 이메일 업데이트 (DB에 저장)
            if (email != null && !email.isEmpty()) {
                try {
                    userDAO.updateProfile(username, email);
                    session.setAttribute("email", email);
                } catch (SQLException e) {
                    System.err.println("[ProfileController] DB 업데이트 오류: " + e.getMessage());
                }
            }
            
            // 이름은 세션에만 저장 (DB에 name 컬럼이 없음)
            if (name != null && !name.isEmpty()) {
                session.setAttribute("name", name);
            }
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "true");
            response.put("message", "프로필이 저장되었습니다.");
            
            System.out.println("[ProfileController] 프로필 저장 성공");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("[ProfileController] 프로필 저장 오류: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "프로필 저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    /**
     * 사용자의 기존 프로필 이미지 삭제
     */
    private void deleteOldProfileImage(String username) {
        try {
            String realPath = servletContext.getRealPath("/");
            if (realPath == null) {
                realPath = System.getProperty("user.dir");
            }
            Path uploadPath = Paths.get(realPath, UPLOAD_DIR);
            if (Files.exists(uploadPath)) {
                Files.list(uploadPath)
                    .filter(path -> {
                        String filename = path.getFileName().toString();
                        return filename.startsWith(username + "_");
                    })
                    .forEach(path -> {
                        try {
                            Files.delete(path);
                            System.out.println("[ProfileController] 기존 이미지 삭제: " + path.getFileName());
                        } catch (IOException e) {
                            System.err.println("[ProfileController] 기존 이미지 삭제 실패: " + path.getFileName());
                        }
                    });
            }
        } catch (IOException e) {
            System.err.println("[ProfileController] 기존 이미지 검색 오류: " + e.getMessage());
        }
    }
}

