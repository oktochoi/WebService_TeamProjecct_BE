package hello.webservice_project_be.service;

import hello.webservice_project_be.dao.UserDAO;
import hello.webservice_project_be.infrastructure.ApplicationDataSource;
import hello.webservice_project_be.model.User;
import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private final UserDAO userDAO = new UserDAO();

    @Override
    public List<User> listUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setUserPassword(rs.getString("user_password"));
                user.setEmail(rs.getString("email"));
                user.setUserRole(rs.getString("user_role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                users.add(user);
            }
        } catch (Exception e) {
            System.err.println("[UserServiceImpl] listUsers 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean deleteUserById(int userId) {
        try {
            return userDAO.delete(userId);
        } catch (Exception e) {
            System.err.println("[UserServiceImpl] deleteUserById 오류: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

