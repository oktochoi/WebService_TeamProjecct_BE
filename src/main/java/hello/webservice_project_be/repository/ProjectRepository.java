package hello.webservice_project_be.repository;

import hello.webservice_project_be.model.Project;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ProjectRepository {

    @Autowired
    private ProjectMapper projectMapper;

    public List<Project> findAllByUserId(String userId) {
        return projectMapper.findAllByUserId(userId);
    }

    public Project findById(int id) {
        return projectMapper.findById(id);
    }

    public int insert(Project project) {
        return projectMapper.insert(project);
    }

    public int update(Project project) {
        return projectMapper.update(project);
    }

    public int delete(int id, String userId) {
        return projectMapper.delete(id, userId);
    }
}

