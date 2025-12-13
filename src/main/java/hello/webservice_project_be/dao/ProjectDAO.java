package hello.webservice_project_be.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import hello.webservice_project_be.infrastructure.ApplicationDataSource;
import hello.webservice_project_be.model.Project;

public class ProjectDAO {

    /**
     * 모든 프로젝트를 조회합니다.
     */
    public List<Project> getAllProjects(String userId) throws SQLException {
        System.out.println("[ProjectDAO] getAllProjects 호출 - userId=" + userId);
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT * FROM projects WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    projects.add(mapResultSetToProject(rs));
                }
            }
        }

        System.out.println("[ProjectDAO] getAllProjects 결과 개수=" + projects.size());
        return projects;
    }

    /**
     * ID로 프로젝트를 조회합니다.
     */
    public Project getProjectById(int id) throws SQLException {
        System.out.println("[ProjectDAO] getProjectById 호출 - id=" + id);
        String sql = "SELECT * FROM projects WHERE id = ?";
        Project project = null;

        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    project = mapResultSetToProject(rs);
                }
            }
        }

        System.out.println("[ProjectDAO] getProjectById 결과=" + (project != null));
        return project;
    }

    /**
     * 새 프로젝트를 생성합니다.
     */
    public int createProject(Project project) throws SQLException {
        System.out.println("[ProjectDAO] createProject 호출 - name=" + project.getName() + ", userId=" + project.getUserId());
        String sql = "INSERT INTO projects (name, description, repo_url, status, members, contribution_score, total_commits, total_pull_requests, total_issues, user_id, created_at, last_updated) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        int generatedId = 0;

        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, project.getName());
            pstmt.setString(2, project.getDescription());
            pstmt.setString(3, project.getRepoUrl());
            pstmt.setString(4, project.getStatus());
            pstmt.setInt(5, project.getMembers());
            pstmt.setInt(6, project.getContributionScore());
            pstmt.setInt(7, project.getTotalCommits());
            pstmt.setInt(8, project.getTotalPullRequests());
            pstmt.setInt(9, project.getTotalIssues());
            pstmt.setString(10, project.getUserId());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedId = generatedKeys.getInt(1);
                    }
                }
            }
        }

        System.out.println("[ProjectDAO] createProject 생성된 ID=" + generatedId);
        return generatedId;
    }

    /**
     * 프로젝트를 업데이트합니다.
     */
    public boolean updateProject(Project project) throws SQLException {
        System.out.println("[ProjectDAO] updateProject 호출 - id=" + project.getId() + ", userId=" + project.getUserId());
        String sql = "UPDATE projects SET name = ?, description = ?, repo_url = ?, status = ?, " +
                     "members = ?, contribution_score = ?, total_commits = ?, total_pull_requests = ?, total_issues = ?, last_updated = NOW() WHERE id = ? AND user_id = ?";

        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, project.getName());
            pstmt.setString(2, project.getDescription());
            pstmt.setString(3, project.getRepoUrl());
            pstmt.setString(4, project.getStatus());
            pstmt.setInt(5, project.getMembers());
            pstmt.setInt(6, project.getContributionScore());
            pstmt.setInt(7, project.getTotalCommits());
            pstmt.setInt(8, project.getTotalPullRequests());
            pstmt.setInt(9, project.getTotalIssues());
            pstmt.setInt(10, project.getId());
            pstmt.setString(11, project.getUserId());

            boolean updated = pstmt.executeUpdate() > 0;
            System.out.println("[ProjectDAO] updateProject 결과=" + updated);
            return updated;
        }
    }

    /**
     * 프로젝트를 삭제합니다.
     */
    public boolean deleteProject(int id, String userId) throws SQLException {
        System.out.println("[ProjectDAO] deleteProject 호출 - id=" + id + ", userId=" + userId);
        String sql = "DELETE FROM projects WHERE id = ? AND user_id = ?";

        try (Connection conn = ApplicationDataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.setString(2, userId);

            boolean deleted = pstmt.executeUpdate() > 0;
            System.out.println("[ProjectDAO] deleteProject 결과=" + deleted);
            return deleted;
        }
    }

    /**
     * ResultSet을 Project 객체로 변환합니다.
     */
    private Project mapResultSetToProject(ResultSet rs) throws SQLException {
        Project project = new Project();
        int id = rs.getInt("id");
        project.setId(id);
        System.out.println("[ProjectDAO] mapResultSetToProject - id: " + id);
        
        project.setName(rs.getString("name"));
        project.setDescription(rs.getString("description"));
        project.setRepoUrl(rs.getString("repo_url"));
        project.setStatus(rs.getString("status"));
        project.setMembers(rs.getInt("members"));
        project.setContributionScore(rs.getInt("contribution_score"));
        // 새로운 필드들 (컬럼이 없을 수 있으므로 try-catch로 처리)
        try {
            project.setTotalCommits(rs.getInt("total_commits"));
        } catch (SQLException e) {
            project.setTotalCommits(0);
        }
        try {
            project.setTotalPullRequests(rs.getInt("total_pull_requests"));
        } catch (SQLException e) {
            project.setTotalPullRequests(0);
        }
        try {
            project.setTotalIssues(rs.getInt("total_issues"));
        } catch (SQLException e) {
            project.setTotalIssues(0);
        }
        project.setCreatedAt(rs.getTimestamp("created_at"));
        project.setLastUpdated(rs.getTimestamp("last_updated"));
        project.setUserId(rs.getString("user_id"));
        return project;
    }
}

