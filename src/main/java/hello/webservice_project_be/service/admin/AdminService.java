package hello.webservice_project_be.service.admin;

import hello.webservice_project_be.infrastructure.ApplicationDataSource;
import hello.webservice_project_be.model.User;
import hello.webservice_project_be.service.UserService;
import hello.webservice_project_be.dao.UserDAO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Collections;
import java.util.List;

@Service
@Transactional
public class AdminService {

    private static final Logger logger = LoggerFactory.getLogger(AdminService.class);

    private final UserService userService;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    public AdminService(UserService userService) {
        this.userService = userService;
    }

    // ===== 사용자 목록 =====
    public List<User> listUsers() {
        try {
            return userService.listUsers();
        } catch (Exception e) {
            logger.error("[AdminService] listUsers 오류: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    // ===== 관리자 권한 체크 + 사용자 삭제 =====
    public boolean deleteUserById(int userId, User adminUser) {

        logger.info("[AdminService] deleteUserById 호출 - userId={}, adminUser.id={}, adminUser.role={}", userId,
                adminUser == null ? null : adminUser.getId(), adminUser == null ? null : adminUser.getUserRole());

        // 1. 관리자 체크
        if (adminUser == null) {
            logger.warn("[AdminService] 삭제 시도자 정보 없음");
            return false;
        }

        String role = adminUser.getUserRole();
        if (role == null ||
                !(role.equalsIgnoreCase("ADMIN") || role.equalsIgnoreCase("ROLE_ADMIN"))) {
            logger.warn("[AdminService] 삭제 권한 없음 - role={}", role);
            return false;
        }

        // 2. 자기 자신 삭제 방지
        if (adminUser.getId() == userId) {
            logger.warn("[AdminService] 관리자 본인 삭제 시도 차단 - id={}", userId);
            return false;
        }

        try {
            return deleteUserHard(userId);
        } catch (Exception e) {
            logger.error("[AdminService] deleteUserById 실패 id={}", userId, e);
            return false;
        }
    }

    // ===== 실제 Hard Delete 로직 (findById 사용 안 함) =====
    private boolean deleteUserHard(int userId) throws Exception {

        Connection conn = null;

        try {
            // 1. userDAO.findById 사용하여 대상 유저 찾기
            User target = null;
            try {
                if (userDAO != null) {
                    target = userDAO.findById(userId);
                } else {
                    // fallback: service로 리스트 조회
                    for (User u : userService.listUsers()) {
                        if (u.getId() == userId) {
                            target = u;
                            break;
                        }
                    }
                }
            } catch (Exception e) {
                logger.error("[AdminService] 대상 유저 조회 중 예외 id={}", userId, e);
                target = null;
            }

            if (target == null) {
                logger.warn("[AdminService] 삭제 대상 유저 없음 id={}", userId);
                return false;
            }

            String username = target.getUsername(); // projects.owner
            String email = target.getEmail();       // board.email

            logger.info("[AdminService] 삭제 대상 확인 id={}, username={}, email={}", userId, username, email);

            conn = ApplicationDataSource.getNewConnection();
            boolean prevAuto = conn.getAutoCommit();
            conn.setAutoCommit(false);

            // 2. board 삭제
            String deleteBoardSql = "DELETE FROM board WHERE email = ?";
            int deletedBoard = 0;
            if (email != null && !email.trim().isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(deleteBoardSql)) {
                    ps.setString(1, email);
                    deletedBoard = ps.executeUpdate();
                }
            } else {
                logger.info("[AdminService] board 삭제 대상 email 없음, 스킵 id={}", userId);
            }
            logger.info("[AdminService] board 삭제 영향행수: {} for email={}", deletedBoard, email);

            // 3. projects 삭제
            String deleteProjectsSql = "DELETE FROM projects WHERE owner = ?";
            int deletedProjects = 0;
            if (username != null && !username.trim().isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement(deleteProjectsSql)) {
                    ps.setString(1, username);
                    deletedProjects = ps.executeUpdate();
                }
            } else {
                logger.info("[AdminService] projects 삭제 대상 username 없음, 스킵 id={}", userId);
            }
            logger.info("[AdminService] projects 삭제 영향행수: {} for owner={}", deletedProjects, username);

            // 4. users 삭제
            String deleteUserSql = "DELETE FROM users WHERE id = ?";
            int affected;
            try (PreparedStatement ps = conn.prepareStatement(deleteUserSql)) {
                ps.setInt(1, userId);
                affected = ps.executeUpdate();
            }
            logger.info("[AdminService] users 삭제 영향행수: {} for id={}", affected, userId);

            if (affected <= 0) {
                conn.rollback();
                conn.setAutoCommit(prevAuto);
                logger.warn("[AdminService] users 삭제 영향 없음, 롤백 id={}", userId);
                return false;
            }

            conn.commit();
            conn.setAutoCommit(prevAuto);
            logger.info("[AdminService] 사용자 삭제 커밋 완료 id={}", userId);
            return true;

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            logger.error("[AdminService] deleteUserHard 예외 발생 id={}", userId, e);
            throw e;

        } finally {
            if (conn != null) conn.close();
        }
    }
}
