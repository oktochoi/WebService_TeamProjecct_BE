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
        // 프로젝트 생성 시 상태를 "분석중"으로 설정
        if (project.getStatus() == null || project.getStatus().isEmpty()) {
            project.setStatus("분석중");
        }
        
        int projectId = projectRepository.insert(project);
        
        // repo_url이 있으면 비동기로 분석 시작
        if (projectId > 0 && project.getRepoUrl() != null && !project.getRepoUrl().isEmpty()) {
            projectAnalysisService.analyzeProjectAsync(projectId, project.getRepoUrl());
        }
        
        return projectId;
    }
    
    public boolean updateProject(Project project) {
        return projectRepository.update(project) > 0;
    }
    
    public boolean deleteProject(int id, String userId) {
        return projectRepository.delete(id, userId) > 0;
    }
}

