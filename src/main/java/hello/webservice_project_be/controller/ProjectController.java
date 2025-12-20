package hello.webservice_project_be.controller;

import hello.webservice_project_be.model.Project;
import hello.webservice_project_be.service.ProjectService;
import hello.webservice_project_be.service.GitHubService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/api/projects")
public class ProjectController {
    
    @Autowired
    private ProjectService projectService;
    
    @Autowired
    private GitHubService githubService;
    
    @GetMapping
    @ResponseBody
    public ResponseEntity<?> getAllProjects(HttpSession session) {
        System.out.println("[ProjectController] getAllProjects 호출 시작");
        try {
            System.out.println("[ProjectController] 세션 존재: " + (session != null));
            if (session != null) {
                System.out.println("[ProjectController] authenticated: " + session.getAttribute("authenticated"));
                System.out.println("[ProjectController] username: " + session.getAttribute("username"));
            }
            
            String userId = (String) session.getAttribute("username");
            System.out.println("[ProjectController] userId: " + userId);
            
            if (userId == null) {
                System.out.println("[ProjectController] 인증 실패 - userId가 null");
                Map<String, String> error = new HashMap<>();
                error.put("error", "인증이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
            }
            
            System.out.println("[ProjectController] 프로젝트 목록 조회 시작 - userId: " + userId);
            List<Project> projects = projectService.getAllProjects(userId);
            System.out.println("[ProjectController] 프로젝트 개수: " + (projects != null ? projects.size() : 0));
            
            // 디버깅: 각 프로젝트의 ID 확인
            if (projects != null && !projects.isEmpty()) {
                for (Project p : projects) {
                    System.out.println("[ProjectController] 프로젝트 ID: " + p.getId() + ", 이름: " + p.getName());
                }
            }
            
            System.out.println("[ProjectController] 응답 반환");
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            System.err.println("[ProjectController] 오류 발생: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "프로젝트를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<?> getProjectById(@PathVariable int id, HttpSession session) {
        try {
            String userId = (String) session.getAttribute("username");
            Project project = projectService.getProjectById(id);
            
            if (project == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "프로젝트를 찾을 수 없습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
            }
            
            if (!project.getUserId().equals(userId)) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "접근 권한이 없습니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error);
            }
            
            // GitHub API에서 최신 데이터 가져오기
            if (project.getRepoUrl() != null && !project.getRepoUrl().isEmpty()) {
                try {
                    Map<String, Object> githubStats = githubService.getDetailedRepositoryStats(project.getRepoUrl());
                    
                    // 커밋, PR, 이슈 수 업데이트
                    if (githubStats.containsKey("totalCommits")) {
                        project.setTotalCommits((Integer) githubStats.get("totalCommits"));
                    }
                    if (githubStats.containsKey("totalPullRequests")) {
                        project.setTotalPullRequests((Integer) githubStats.get("totalPullRequests"));
                    }
                    if (githubStats.containsKey("totalIssues")) {
                        project.setTotalIssues((Integer) githubStats.get("totalIssues"));
                    }
                    if (githubStats.containsKey("memberCount")) {
                        project.setMembers((Integer) githubStats.get("memberCount"));
                    }
                    
                    // 기여도 점수 계산 (간단한 알고리즘)
                    int contributionScore = calculateContributionScore(githubStats);
                    project.setContributionScore(contributionScore);
                    
                    // 기여자 정보 가져오기
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> contributors = (List<Map<String, Object>>) githubStats.get("contributors");
                    
                    // 응답에 기여자 정보 포함
                    Map<String, Object> response = new HashMap<>();
                    response.put("id", project.getId());
                    response.put("name", project.getName());
                    response.put("description", project.getDescription());
                    response.put("repoUrl", project.getRepoUrl());
                    response.put("status", project.getStatus());
                    response.put("members", project.getMembers());
                    response.put("contributionScore", project.getContributionScore());
                    response.put("totalCommits", project.getTotalCommits());
                    response.put("totalPullRequests", project.getTotalPullRequests());
                    response.put("totalIssues", project.getTotalIssues());
                    response.put("userId", project.getUserId());
                    response.put("createdAt", project.getCreatedAt());
                    response.put("lastUpdated", project.getLastUpdated());
                    response.put("contributors", contributors != null ? contributors : new java.util.ArrayList<>());
                    
                    return ResponseEntity.ok(response);
                } catch (Exception e) {
                    System.err.println("[ProjectController] GitHub API 호출 실패: " + e.getMessage());
                    // GitHub API 호출 실패 시에도 기본 프로젝트 정보는 반환
                    e.printStackTrace();
                }
            }
            
            // GitHub URL이 없거나 API 호출 실패 시 기본 프로젝트 정보 반환
            Map<String, Object> response = new HashMap<>();
            response.put("id", project.getId());
            response.put("name", project.getName());
            response.put("description", project.getDescription());
            response.put("repoUrl", project.getRepoUrl());
            response.put("status", project.getStatus());
            response.put("members", project.getMembers());
            response.put("contributionScore", project.getContributionScore());
            response.put("totalCommits", project.getTotalCommits());
            response.put("totalPullRequests", project.getTotalPullRequests());
            response.put("totalIssues", project.getTotalIssues());
            response.put("userId", project.getUserId());
            response.put("createdAt", project.getCreatedAt());
            response.put("lastUpdated", project.getLastUpdated());
            response.put("contributors", new java.util.ArrayList<>());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    /**
     * 기여도 점수를 계산합니다.
     */
    private int calculateContributionScore(Map<String, Object> stats) {
        int score = 0;
        
        // 커밋 수 기반 점수 (최대 40점)
        Integer totalCommits = (Integer) stats.get("totalCommits");
        if (totalCommits != null) {
            score += Math.min(totalCommits / 10, 40);
        }
        
        // Pull Requests 기반 점수 (최대 30점)
        Integer totalPRs = (Integer) stats.get("totalPullRequests");
        if (totalPRs != null) {
            score += Math.min(totalPRs * 2, 30);
        }
        
        // Issues 기반 점수 (최대 20점)
        Integer totalIssues = (Integer) stats.get("totalIssues");
        if (totalIssues != null) {
            score += Math.min(totalIssues * 2, 20);
        }
        
        // 팀원 수 기반 점수 (최대 10점)
        Integer memberCount = (Integer) stats.get("memberCount");
        if (memberCount != null && memberCount > 0) {
            score += Math.min(memberCount * 2, 10);
        }
        
        return Math.min(score, 100); // 최대 100점
    }
    
    @PostMapping
    @ResponseBody
    public ResponseEntity<?> createProject(@RequestBody Project project, HttpSession session) {
        try {
            String userId = (String) session.getAttribute("username");
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "인증이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
            }
            
            project.setUserId(userId);
            int projectId = projectService.createProject(project);
            
            if (projectId > 0) {
                project.setId(projectId);
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "프로젝트가 생성되었습니다.");
                response.put("project", project);
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> error = new HashMap<>();
                error.put("error", "프로젝트 생성에 실패했습니다.");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "프로젝트 생성 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<?> updateProject(@PathVariable int id, @RequestBody Project project, HttpSession session) {
        try {
            String userId = (String) session.getAttribute("username");
            Project existingProject = projectService.getProjectById(id);
            
            if (existingProject == null || !existingProject.getUserId().equals(userId)) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "프로젝트를 찾을 수 없습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
            }
            
            project.setId(id);
            project.setUserId(userId);
            boolean success = projectService.updateProject(project);
            
            if (success) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "프로젝트가 업데이트되었습니다.");
                response.put("project", project);
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> error = new HashMap<>();
                error.put("error", "프로젝트 업데이트에 실패했습니다.");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteProject(@PathVariable int id, HttpSession session) {
        try {
            String userId = (String) session.getAttribute("username");
            Project project = projectService.getProjectById(id);
            
            if (project == null || !project.getUserId().equals(userId)) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "프로젝트를 찾을 수 없습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
            }
            
            boolean success = projectService.deleteProject(id, userId);
            
            if (success) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "프로젝트가 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> error = new HashMap<>();
                error.put("error", "프로젝트 삭제에 실패했습니다.");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}

