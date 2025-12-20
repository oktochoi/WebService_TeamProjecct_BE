package hello.webservice_project_be.dao;

import hello.webservice_project_be.infrastructure.ApplicationDataSource;
import hello.webservice_project_be.model.User;

import java.sql.*;

public class UserDAO {

    public int create(User user) throws SQLException {
        System.out.println("[UserDAO] create 호출 - username=" + user.getUsername());
        String sql = "INSERT INTO users (username, user_password, email, user_role, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getUserPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getUserRole());

            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        System.out.println("[UserDAO] create 성공 - id=" + id);
                        return id;
                    }
                }
            }
        }
        return 0;
    }

    public User findById(int id) throws SQLException {
        System.out.println("[UserDAO] findById 호출 - id=" + id);
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = mapRow(rs);
                    System.out.println("[UserDAO] findById 성공 - username=" + user.getUsername());
                    return user;
                }
            }
        }
        return null;
    }

    public User findByUsername(String username) throws SQLException {
        System.out.println("[UserDAO] findByUsername 호출 - username=" + username);
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = mapRow(rs);
                    System.out.println("[UserDAO] findByUsername 성공 - id=" + user.getId());
                    return user;
                }
            }
        }
        System.out.println("[UserDAO] findByUsername 결과 없음");
        return null;
    }

    public boolean updatePassword(int id, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET user_password = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, hashedPassword);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * 모든 사용자 조회 (관리자용)
     */
    public java.util.List<User> getAllUsers() throws SQLException {
        System.out.println("[UserDAO] getAllUsers 호출");
        String sql = "SELECT * FROM users ORDER BY id DESC";
        java.util.List<User> users = new java.util.ArrayList<>();
        
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapRow(rs));
            }
        }
        
        System.out.println("[UserDAO] getAllUsers 결과: " + users.size() + "명");
        return users;
    }
    
    /**
     * ID로 사용자 조회
     */
    public User getUserById(int id) throws SQLException {
        return findById(id);
    }
    
    /**
     * 사용자 삭제 (관리자용)
     */
    public boolean deleteUser(int id) throws SQLException {
        return delete(id);
    }
    
    /**
     * 프로필 이미지 URL 업데이트
     */
    public boolean updateProfileImageUrl(String username, String imageUrl) throws SQLException {
        System.out.println("[UserDAO] updateProfileImageUrl 호출 - username=" + username + ", imageUrl=" + imageUrl);
        String sql = "UPDATE users SET profile_image_url = ?, updated_at = NOW() WHERE username = ?";
        
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, imageUrl);
            pstmt.setString(2, username);
            
            boolean updated = pstmt.executeUpdate() > 0;
            System.out.println("[UserDAO] updateProfileImageUrl 결과=" + updated);
            return updated;
        }
    }
    
    /**
     * 프로필 이미지 URL 조회
     */
    public String getProfileImageUrl(String username) throws SQLException {
        System.out.println("[UserDAO] getProfileImageUrl 호출 - username=" + username);
        String sql = "SELECT profile_image_url FROM users WHERE username = ?";
        
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String imageUrl = rs.getString("profile_image_url");
                    System.out.println("[UserDAO] getProfileImageUrl 결과=" + imageUrl);
                    return imageUrl;
                }
            }
        }
        return null;
    }
    
    /**
     * 프로필 정보 업데이트 (이름, 이메일)
     * 주의: DB에는 name 컬럼이 없으므로 세션만 업데이트
     */
    public boolean updateProfile(String username, String email) throws SQLException {
        System.out.println("[UserDAO] updateProfile 호출 - username=" + username + ", email=" + email);
        String sql = "UPDATE users SET email = ?, updated_at = NOW() WHERE username = ?";
        
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, username);
            
            boolean updated = pstmt.executeUpdate() > 0;
            System.out.println("[UserDAO] updateProfile 결과=" + updated);
            return updated;
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setUserPassword(rs.getString("user_password"));
        user.setEmail(rs.getString("email"));
        user.setUserRole(rs.getString("user_role"));
        try {
            user.setProfileImageUrl(rs.getString("profile_image_url"));
        } catch (SQLException e) {
            // 컬럼이 없을 수 있으므로 무시
            user.setProfileImageUrl(null);
        }
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
}

