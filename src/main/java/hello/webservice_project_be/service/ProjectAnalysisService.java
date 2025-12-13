package hello.webservice_project_be.service;

import hello.webservice_project_be.model.Project;
import hello.webservice_project_be.repository.ProjectRepository;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

@Service
public class ProjectAnalysisService {
    
    @Autowired
    private GitHubService githubService;
    
    @Autowired
    private ProjectRepository projectRepository;
    
    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";
    
    /**
     * OpenAI API 키를 환경 변수 또는 시스템 프로퍼티에서 가져옵니다.
     * 환경 변수 OPENAI_API_KEY 또는 시스템 프로퍼티 openai.api.key를 확인합니다.
     */
    private String getOpenAIApiKey() {
        // 1. 환경 변수에서 확인
        String apiKey = System.getenv("OPENAI_API_KEY");
        if (apiKey != null && !apiKey.isEmpty()) {
            return apiKey;
        }
        
        // 2. 시스템 프로퍼티에서 확인
        apiKey = System.getProperty("openai.api.key");
        if (apiKey != null && !apiKey.isEmpty()) {
            return apiKey;
        }
        
        // 3. 없으면 null 반환 (에러 처리)
        System.err.println("[ProjectAnalysisService] 경고: OPENAI_API_KEY 환경 변수 또는 openai.api.key 시스템 프로퍼티가 설정되지 않았습니다.");
        return null;
    }
    
    /**
     * 비동기로 프로젝트를 분석하고 업데이트합니다.
     */
    @Async("taskExecutor")
    public void analyzeProjectAsync(int projectId, String repoUrl) {
        try {
            System.out.println("[ProjectAnalysisService] 프로젝트 분석 시작 - projectId: " + projectId + ", repoUrl: " + repoUrl);
            
            // GitHub URL 유효성 검사
            if (repoUrl == null || repoUrl.isEmpty() || 
                repoUrl.contains("localhost") || repoUrl.contains("127.0.0.1") ||
                !repoUrl.contains("github.com")) {
                System.err.println("[ProjectAnalysisService] 유효하지 않은 GitHub URL: " + repoUrl);
                throw new Exception("유효하지 않은 GitHub 저장소 URL입니다.");
            }
            
            // 1. GitHub API를 통해 저장소 상세 정보 가져오기
            Map<String, Object> stats = githubService.getDetailedRepositoryStats(repoUrl);
            
            // 2. GPT를 통해 프로젝트 분석 (현재는 결과를 사용하지 않지만 향후 확장 가능)
            analyzeWithGPT(stats);
            
            // 3. 분석 결과를 바탕으로 프로젝트 업데이트
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
                
                // 상태를 "진행중"으로 변경 (분석 완료)
                project.setStatus("진행중");
                
                // 프로젝트 업데이트
                projectRepository.update(project);
                
                System.out.println("[ProjectAnalysisService] 프로젝트 분석 완료 - projectId: " + projectId);
            } else {
                System.err.println("[ProjectAnalysisService] 프로젝트를 찾을 수 없습니다 - projectId: " + projectId);
            }
        } catch (Exception e) {
            System.err.println("[ProjectAnalysisService] 프로젝트 분석 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            
            // 오류 발생 시 프로젝트 상태를 "오류"로 설정
            try {
                Project project = projectRepository.findById(projectId);
                if (project != null) {
                    project.setStatus("오류");
                    projectRepository.update(project);
                }
            } catch (Exception updateError) {
                System.err.println("[ProjectAnalysisService] 프로젝트 상태 업데이트 실패: " + updateError.getMessage());
            }
        }
    }
    
    /**
     * GPT를 사용하여 프로젝트를 분석합니다.
     */
    private String analyzeWithGPT(Map<String, Object> stats) throws Exception {
        // 프로젝트 데이터를 JSON 문자열로 변환
        JSONObject projectData = new JSONObject();
        projectData.put("repoInfo", stats.get("repoInfo"));
        projectData.put("contributors", stats.get("contributors"));
        projectData.put("totalContributions", stats.get("totalContributions"));
        
        String projectDataStr = projectData.toString();
        
        // 프롬프트 구성
        String prompt = "다음은 GitHub 프로젝트의 데이터입니다:\n\n" + projectDataStr + 
                       "\n\n이 프로젝트에 대한 간단한 분석을 한국어로 작성해주세요. " +
                       "프로젝트의 주요 특징과 팀원들의 기여도를 요약해주세요.";
        
        // OpenAI API 키 확인
        String apiKey = getOpenAIApiKey();
        if (apiKey == null || apiKey.isEmpty()) {
            throw new Exception("OpenAI API 키가 설정되지 않았습니다. OPENAI_API_KEY 환경 변수를 설정해주세요.");
        }
        
        // OpenAI API 호출
        URL url = new URL(OPENAI_API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        try {
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setDoOutput(true);
            
            JSONObject requestBody = new JSONObject();
            requestBody.put("model", "gpt-3.5-turbo");
            
            JSONObject message = new JSONObject();
            message.put("role", "user");
            message.put("content", prompt);
            
            requestBody.put("messages", new org.json.JSONArray().put(message));
            requestBody.put("max_tokens", 500);
            requestBody.put("temperature", 0.7);
            
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = requestBody.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String inputLine;
                
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                JSONObject jsonResponse = new JSONObject(response.toString());
                if (jsonResponse.has("choices") && jsonResponse.getJSONArray("choices").length() > 0) {
                    JSONObject choice = jsonResponse.getJSONArray("choices").getJSONObject(0);
                    JSONObject messageObj = choice.getJSONObject("message");
                    return messageObj.getString("content");
                } else {
                    return "AI 분석 결과를 가져올 수 없습니다.";
                }
            } else {
                BufferedReader errorReader = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                StringBuilder errorResponse = new StringBuilder();
                String errorLine;
                
                while ((errorLine = errorReader.readLine()) != null) {
                    errorResponse.append(errorLine);
                }
                errorReader.close();
                
                System.err.println("OpenAI API 오류 응답: " + errorResponse.toString());
                throw new Exception("OpenAI API 호출 실패: HTTP " + responseCode);
            }
        } finally {
            conn.disconnect();
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

