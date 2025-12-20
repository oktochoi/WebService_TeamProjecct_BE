package hello.webservice_project_be.service;

import hello.webservice_project_be.model.Project;
import hello.webservice_project_be.repository.ProjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ProjectService {
    
    @Autowired
    private ProjectRepository projectRepository;
    
    @Autowired
    private ProjectAnalysisService projectAnalysisService;
    
    public List<Project> getAllProjects(String userId) {
        return projectRepository.findAllByUserId(userId);
    }
    
    public Project getProjectById(int id) {
        return projectRepository.findById(id);
    }
    
    public int createProject(Project project) {
        // 프로젝트 생성 시 상태를 "진행중"으로 설정
        if (project.getStatus() == null || project.getStatus().isEmpty()) {
            project.setStatus("진행중");
        }
        
        int projectId = projectRepository.insert(project);
        
        // repo_url이 있으면 비동기로 GitHub 통계 업데이트
        if (projectId > 0 && project.getRepoUrl() != null && !project.getRepoUrl().isEmpty()) {
            projectAnalysisService.updateGitHubStatsAsync(projectId, project.getRepoUrl());
        }
        
        return projectId;
    }
    
    public boolean updateProject(Project project) {
        return projectRepository.update(project) > 0;
    }
    
    public boolean deleteProject(int id, String userId) {
        return projectRepository.delete(id, userId) > 0;
    }
    
    public boolean deleteAllProjectsByUserId(String userId) {
        int deletedCount = projectRepository.deleteByUserId(userId);
        System.out.println("[ProjectService] 사용자의 모든 프로젝트 삭제: userId=" + userId + ", 삭제된 프로젝트 수=" + deletedCount);
        return deletedCount >= 0; // 0개 이상 삭제되면 성공
    }
}

