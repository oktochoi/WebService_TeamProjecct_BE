package hello.webservice_project_be.repository;

import hello.webservice_project_be.model.Project;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ProjectMapper {
    
    List<Project> findAllByUserId(@Param("userId") String userId);
    
    Project findById(@Param("id") int id);
    
    int insert(Project project);
    
    int update(Project project);
    
    int delete(@Param("id") int id, @Param("userId") String userId);
    
    int deleteByUserId(@Param("userId") String userId);
}

