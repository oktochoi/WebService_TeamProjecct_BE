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

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setUserPassword(rs.getString("user_password"));
        user.setEmail(rs.getString("email"));
        user.setUserRole(rs.getString("user_role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
}

