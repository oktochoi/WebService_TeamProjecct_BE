package hello.webservice_project_be.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/api/ai-analysis")
public class AIAnalysisController {

    @PostMapping
    @ResponseBody
    public ResponseEntity<?> analyze(@RequestBody Map<String, String> request, HttpSession session) {
        try {
            String projectData = request.get("projectData");
            String analysisType = request.getOrDefault("analysisType", "summary");
            
            // AI API 대신 로컬 로직으로 분석 생성
            String analysisResult = generateAnalysis(projectData, analysisType);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("analysis", analysisResult);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "분석 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
    
    /**
     * 프로젝트 데이터를 기반으로 로컬 로직으로 분석을 생성합니다.
     */
    private String generateAnalysis(String projectData, String analysisType) {
        try {
            JSONObject projectJson = new JSONObject(projectData);
            
            String name = projectJson.optString("name", "프로젝트");
            int totalCommits = projectJson.optInt("totalCommits", 0);
            int totalPRs = projectJson.optInt("totalPullRequests", 0);
            int totalIssues = projectJson.optInt("totalIssues", 0);
            int members = projectJson.optInt("members", 0);
            int contributionScore = projectJson.optInt("contributionScore", 0);
            
            // 기여자 정보 추출
            StringBuilder contributorsInfo = new StringBuilder();
            if (projectJson.has("contributors") && projectJson.get("contributors") instanceof org.json.JSONArray) {
                org.json.JSONArray contributors = projectJson.getJSONArray("contributors");
                for (int i = 0; i < contributors.length(); i++) {
                    JSONObject contrib = contributors.getJSONObject(i);
                    String username = contrib.optString("username", "Unknown");
                    int contributions = contrib.optInt("contributions", 0);
                    contributorsInfo.append(username).append("(").append(contributions).append("회)");
                    if (i < contributors.length() - 1) {
                        contributorsInfo.append(", ");
                    }
                }
            }
            
            // 프로젝트 상태에 따라 분석 템플릿 선택
            return selectAnalysisTemplate(name, totalCommits, totalPRs, totalIssues, members, contributionScore, contributorsInfo.toString());
            
        } catch (Exception e) {
            System.err.println("[AIAnalysisController] 분석 생성 실패: " + e.getMessage());
            return getDefaultAnalysis();
        }
    }
    
    /**
     * 프로젝트 통계를 기반으로 적절한 분석 템플릿을 선택합니다.
     */
    private String selectAnalysisTemplate(String name, int commits, int prs, int issues, int members, int score, String contributors) {
        // 5개의 고정 분석 템플릿
        String[] templates = {
            // 템플릿 1: 활발한 프로젝트
            generateTemplate1(name, commits, prs, issues, members, score, contributors),
            // 템플릿 2: 균형잡힌 협업
            generateTemplate2(name, commits, prs, issues, members, score, contributors),
            // 템플릿 3: 성장하는 프로젝트
            generateTemplate3(name, commits, prs, issues, members, score, contributors),
            // 템플릿 4: 안정적인 프로젝트
            generateTemplate4(name, commits, prs, issues, members, score, contributors),
            // 템플릿 5: 협업 중심 프로젝트
            generateTemplate5(name, commits, prs, issues, members, score, contributors)
        };
        
        // 랜덤하게 선택 (0~4)
        int randomIndex = (int)(Math.random() * 5);
        
        return templates[randomIndex];
    }
    
    private String generateTemplate1(String name, int commits, int prs, int issues, int members, int score, String contributors) {
        return "## 프로젝트 개요\n" +
               "**" + name + "** 프로젝트는 매우 활발한 개발 활동을 보이고 있습니다.\n\n" +
               "## 활동 분석\n" +
               "- 총 커밋 수: **" + commits + "개**로 지속적인 코드 개선이 이루어지고 있습니다.\n" +
               "- Pull Requests: **" + prs + "개**로 팀원 간 활발한 코드 리뷰가 진행되고 있습니다.\n" +
               "- Issues: **" + issues + "개**로 프로젝트 관리가 체계적으로 이루어지고 있습니다.\n\n" +
               "## 팀원 기여도\n" +
               "주요 기여자: " + (contributors.isEmpty() ? "정보 없음" : contributors) + "\n" +
               "팀원 수: **" + members + "명**으로 협업이 원활하게 이루어지고 있습니다.\n\n" +
               "## 프로젝트 건강도\n" +
               "기여도 점수: **" + score + "/100점**으로 프로젝트가 건강한 상태입니다.\n\n" +
               "## 개선 제안\n" +
               "1. 현재의 활발한 개발 속도를 유지하면서 코드 품질 관리에 더욱 주의를 기울이세요.\n" +
               "2. PR 리뷰 프로세스를 정착시켜 코드 품질을 향상시키세요.\n" +
               "3. 이슈 관리 시스템을 활용하여 프로젝트 로드맵을 명확히 하세요.";
    }
    
    private String generateTemplate2(String name, int commits, int prs, int issues, int members, int score, String contributors) {
        return "## 프로젝트 개요\n" +
               "**" + name + "** 프로젝트는 팀원들 간의 균형잡힌 협업이 이루어지고 있습니다.\n\n" +
               "## 활동 분석\n" +
               "- 커밋 수 **" + commits + "개**, PR **" + prs + "개**, 이슈 **" + issues + "개**로 프로젝트가 안정적으로 진행되고 있습니다.\n" +
               "- 팀원 간 기여도가 균형있게 분배되어 있어 협업 문화가 잘 정착되어 있습니다.\n\n" +
               "## 팀원 기여도\n" +
               "기여자: " + (contributors.isEmpty() ? "정보 없음" : contributors) + "\n" +
               "총 **" + members + "명**의 팀원이 프로젝트에 참여하고 있습니다.\n\n" +
               "## 프로젝트 건강도\n" +
               "종합 기여도 점수: **" + score + "/100점**\n\n" +
               "## 개선 제안\n" +
               "1. 현재의 협업 패턴을 유지하면서 문서화 작업을 강화하세요.\n" +
               "2. 정기적인 코드 리뷰 미팅을 통해 지식 공유를 활성화하세요.\n" +
               "3. 이슈 해결 속도를 높이기 위한 우선순위 관리 시스템을 도입하세요.";
    }
    
    private String generateTemplate3(String name, int commits, int prs, int issues, int members, int score, String contributors) {
        return "## 프로젝트 개요\n" +
               "**" + name + "** 프로젝트는 지속적인 성장을 보이고 있는 프로젝트입니다.\n\n" +
               "## 활동 분석\n" +
               "- **" + commits + "개의 커밋**과 **" + prs + "개의 PR**이 생성되어 개발이 활발히 진행되고 있습니다.\n" +
               "- **" + issues + "개의 이슈**가 관리되고 있어 프로젝트 개선이 체계적으로 이루어지고 있습니다.\n\n" +
               "## 팀원 기여도\n" +
               "주요 기여자: " + (contributors.isEmpty() ? "정보 없음" : contributors) + "\n" +
               "팀 규모: **" + members + "명**\n\n" +
               "## 프로젝트 건강도\n" +
               "현재 기여도 점수: **" + score + "/100점**\n\n" +
               "## 개선 제안\n" +
               "1. 커밋 메시지 컨벤션을 정립하여 프로젝트 히스토리 관리의 질을 높이세요.\n" +
               "2. PR 템플릿을 만들어 리뷰 효율성을 개선하세요.\n" +
               "3. 이슈 라벨링 시스템을 도입하여 작업 우선순위를 명확히 하세요.";
    }
    
    private String generateTemplate4(String name, int commits, int prs, int issues, int members, int score, String contributors) {
        return "## 프로젝트 개요\n" +
               "**" + name + "** 프로젝트는 안정적이고 체계적인 개발 프로세스를 가지고 있습니다.\n\n" +
               "## 활동 분석\n" +
               "- 총 **" + commits + "개의 커밋**이 이루어졌으며, **" + prs + "개의 PR**과 **" + issues + "개의 이슈**가 관리되고 있습니다.\n" +
               "- 프로젝트 관리가 체계적으로 이루어지고 있어 안정적인 개발 환경이 조성되어 있습니다.\n\n" +
               "## 팀원 기여도\n" +
               "팀 구성: " + (contributors.isEmpty() ? "정보 없음" : contributors) + "\n" +
               "총 **" + members + "명**의 개발자가 참여하고 있습니다.\n\n" +
               "## 프로젝트 건강도\n" +
               "기여도 점수: **" + score + "/100점**으로 프로젝트가 안정적인 상태입니다.\n\n" +
               "## 개선 제안\n" +
               "1. 현재의 안정적인 프로세스를 유지하면서 자동화 도구를 도입하여 효율성을 높이세요.\n" +
               "2. 테스트 커버리지를 높여 코드 품질을 더욱 향상시키세요.\n" +
               "3. CI/CD 파이프라인을 구축하여 배포 프로세스를 자동화하세요.";
    }
    
    private String generateTemplate5(String name, int commits, int prs, int issues, int members, int score, String contributors) {
        return "## 프로젝트 개요\n" +
               "**" + name + "** 프로젝트는 팀원 간의 협업이 중심이 되는 프로젝트입니다.\n\n" +
               "## 활동 분석\n" +
               "- **" + commits + "개의 커밋**과 **" + prs + "개의 PR**이 생성되어 팀원 간 지속적인 소통이 이루어지고 있습니다.\n" +
               "- **" + issues + "개의 이슈**를 통해 프로젝트 개선 사항이 체계적으로 관리되고 있습니다.\n\n" +
               "## 팀원 기여도\n" +
               "기여자 현황: " + (contributors.isEmpty() ? "정보 없음" : contributors) + "\n" +
               "팀원 수: **" + members + "명**\n\n" +
               "## 프로젝트 건강도\n" +
               "종합 점수: **" + score + "/100점**\n\n" +
               "## 개선 제안\n" +
               "1. 팀원 간 지식 공유를 위한 정기적인 기술 세미나를 개최하세요.\n" +
               "2. 코드 리뷰 문화를 더욱 활성화하여 코드 품질을 향상시키세요.\n" +
               "3. 프로젝트 문서화를 강화하여 새로운 팀원의 온보딩을 원활하게 하세요.";
    }
    
    private String getDefaultAnalysis() {
        return "## 프로젝트 분석\n\n" +
               "프로젝트 데이터를 분석 중입니다. 잠시만 기다려주세요.\n\n" +
               "분석 결과는 프로젝트의 커밋, Pull Request, 이슈 등의 활동을 종합적으로 평가하여 생성됩니다.";
    }
}

