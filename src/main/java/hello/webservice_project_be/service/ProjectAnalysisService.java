package hello.webservice_project_be.service;

import hello.webservice_project_be.model.Project;
import hello.webservice_project_be.repository.ProjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class ProjectAnalysisService {
    
    @Autowired
    private GitHubService githubService;
    
    @Autowired
    private ProjectRepository projectRepository;
    
    /**
     * 비동기로 GitHub 통계만 업데이트합니다.
     */
    @Async("taskExecutor")
    public void updateGitHubStatsAsync(int projectId, String repoUrl) {
        try {
            System.out.println("[ProjectAnalysisService] GitHub 통계 업데이트 시작 - projectId: " + projectId + ", repoUrl: " + repoUrl);
            
            // GitHub URL 유효성 검사
            if (repoUrl == null || repoUrl.isEmpty() || 
                repoUrl.contains("localhost") || repoUrl.contains("127.0.0.1") ||
                !repoUrl.contains("github.com")) {
                System.err.println("[ProjectAnalysisService] 유효하지 않은 GitHub URL: " + repoUrl);
                return;
            }
            
            // GitHub API를 통해 저장소 상세 정보 가져오기
            Map<String, Object> stats = githubService.getDetailedRepositoryStats(repoUrl);
            
            // 분석 결과를 바탕으로 프로젝트 업데이트
            Project project = projectRepository.findById(projectId);
            if (project != null) {
                // 기여자 수 설정
                Integer memberCount = (Integer) stats.get("memberCount");
                if (memberCount != null) {
                    project.setMembers(memberCount);
                }
                
                // 커밋 수 설정
                Integer totalCommits = (Integer) stats.get("totalCommits");
                if (totalCommits != null) {
                    project.setTotalCommits(totalCommits);
                }
                
                // Pull Requests 수 설정
                Integer totalPRs = (Integer) stats.get("totalPullRequests");
                if (totalPRs != null) {
                    project.setTotalPullRequests(totalPRs);
                }
                
                // Issues 수 설정
                Integer totalIssues = (Integer) stats.get("totalIssues");
                if (totalIssues != null) {
                    project.setTotalIssues(totalIssues);
                }
                
                // 기여도 점수 계산 (간단한 알고리즘)
                int contributionScore = calculateContributionScore(stats);
                project.setContributionScore(contributionScore);
                
                // 상태를 "분석 완료"로 설정
                project.setStatus("분석 완료");
                
                // 프로젝트 업데이트
                projectRepository.update(project);
                
                System.out.println("[ProjectAnalysisService] GitHub 통계 업데이트 완료 - projectId: " + projectId);
            } else {
                System.err.println("[ProjectAnalysisService] 프로젝트를 찾을 수 없습니다 - projectId: " + projectId);
            }
        } catch (Exception e) {
            System.err.println("[ProjectAnalysisService] GitHub 통계 업데이트 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 저장소 통계를 바탕으로 기여도 점수를 계산합니다.
     */
    private int calculateContributionScore(Map<String, Object> stats) {
        try {
            Integer totalContributions = (Integer) stats.get("totalContributions");
            Integer memberCount = (Integer) stats.get("memberCount");
            
            if (totalContributions == null || memberCount == null || memberCount == 0) {
                return 0;
            }
            
            // 간단한 점수 계산: 총 기여도 / 팀원 수 * 10 (최대 100점)
            int score = (totalContributions / memberCount) * 10;
            return Math.min(score, 100);
        } catch (Exception e) {
            System.err.println("기여도 점수 계산 중 오류: " + e.getMessage());
            return 0;
        }
    }
}

